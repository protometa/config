function dr --wraps='docker run --rm -it -P' --description 'alias dr=docker run --rm -it -P'
  docker run --rm -it -P $argv; 
end
