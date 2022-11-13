function drw --wraps='dr' --description 'docker run mounting current directory'
  dr -v (pwd):/(basename (pwd)) -w /(basename (pwd)) $argv;
end
