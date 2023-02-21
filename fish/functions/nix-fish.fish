function nix-fish --wraps='nix-shell --command fish' --description 'alias nix-fish=nix-shell --command fish'
  nix-shell --command fish $argv;
end
