function dcr --wraps='dc run --rm -it --service-ports' --description 'alias dcr=dc run --rm -it --service-ports'
  dc run --rm -it --service-ports $argv; 
end
