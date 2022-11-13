function cmdsubst --argument file
 cat $file | string replace -r '^' 'echo ' | fish; 
end
