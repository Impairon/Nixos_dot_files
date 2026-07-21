# ------- Star ship --------------
eval "$(starship init bash)"

# ------- Ism allah aleh --------

echo "  
   ____________________________________________
 < hello Abo Ayman let's get some tuna going 💪 >
   --------------------------------------------
  (\__/)||
_ (•ㅅ•)||
 \/o   \っ
"

# ------- Make life easy ---------

alias cls='clear'
alias rm='rm -i'
alias off='systemctl poweroff'
alias nosleep='systemd-inhibit --what=idle:sleep:shutdown --why="Long download running" --who="aboayman" bash'
alias zd='zeditor'
alias poise='cd ~/poise-voice-isolator && nix-shell --run "python -m stream_denoiser.tui \
  --model poise-large \
  --chunk-size 2048 \
  --latency 30 \
  --threshold 0.3"'
alias cpu='nix shell nixpkgs#linuxPackages.cpupower --extra-experimental-features flakes -c sudo cpupower frequency-set -g performance'
# set ============👆to schedutil for normal use if you want 
alias color='~/.color.sh'

# ------- Mutx -------------------

alias mute='cd ~/ma_mute && nix-shell .shell.nix'
alias server='cd ~/ma_mute && ~/ma_mute/server/server.py'

# ------- Nix --------------------

alias system='sudo nvim /etc/nixos/modules/system.nix'
alias programs='sudo nvim /etc/nixos/modules/programs.nix'
alias fwall='sudo nvim /etc/nixos/modules/firewall.nix'
alias gen='sudo nix-env --profile /nix/var/nix/profiles/system'




