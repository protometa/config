function ff --description 'fzf lines of files in dir'
rg -n . | fzf --preview "echo {}" --preview-window="bottom:5:wrap"
end
