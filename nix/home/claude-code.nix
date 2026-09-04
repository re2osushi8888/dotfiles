# Claude Code の settings.json は CLI 自身が実行時に書き込む
# (/model, /theme, /permissions など) ため symlink で git 管理下に置かず、
# 宣言したい設定だけをここに Nix で書き、activation 時に jq でライブファイルへ
# 強制マージする。ライブファイル側にしかないキー (model, theme 等) はそのまま
# 保持され、git の diff には一切現れない。
{ config, pkgs, lib, ... }:
let
  claudeDir = "${config.home.homeDirectory}/.claude";
  jq = lib.getExe pkgs.jq;
  jsonFormat = pkgs.formats.json { };

  settings = {
    attribution.commit = "";
    hooks.PreToolUse = [
      {
        matcher = "Bash";
        hooks = [
          { type = "command"; command = "$HOME/.claude/hooks/block-dangerous.sh"; }
        ];
      }
    ];
    statusLine = {
      type = "command";
      command = "bash $HOME/.claude/statusline-command.sh";
    };
    enabledPlugins = {
      "typescript-lsp@claude-plugins-official" = true;
      "document-skills@anthropic-agent-skills" = true;
      "lua-lsp@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "gopls-lsp@claude-plugins-official" = true;
    };
    extraKnownMarketplaces = {
      "anthropic-agent-skills".source = {
        source = "github";
        repo = "anthropics/skills";
      };
    };
    skipDangerousModePermissionPrompt = true;
    skipAutoPermissionPrompt = true;
  };

  generated = jsonFormat.generate "claude-settings.json" settings;
in
{
  home.activation.writeClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS_FILE="${claudeDir}/settings.json"
    mkdir -p "${claudeDir}"

    if [ -f "$SETTINGS_FILE" ]; then
      TMP_FILE="$(mktemp "${claudeDir}/.settings.json.XXXXXX")"
      if ! ${jq} -s '.[0] * .[1]' "$SETTINGS_FILE" ${generated} > "$TMP_FILE"; then
        rm -f "$TMP_FILE"
        exit 1
      fi
      mv "$TMP_FILE" "$SETTINGS_FILE"
    else
      cp --no-preserve=mode,ownership ${generated} "$SETTINGS_FILE"
    fi
    chmod 644 "$SETTINGS_FILE"
  '';
}
