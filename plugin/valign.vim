function! s:displaylen(str)
	"only for Chinese, sc. 3B/character
	let l:len = len(a:str)
	let l:chars = strchars(a:str)
	let l:offset = (len(a:str) - strchars(a:str))/2
	return l:len - l:offset
endfunction
function! s:get_line_layout() range
	let l:layout = {}
	let l:word = {}
	for l:i in range(line("'<") , line("'>"))
		let l:indent = strpart(getline(l:i) , 0 , match(getline(l:i) , '\S'))
		let l:word[l:i] = split(getline(l:i) , '')
		let l:layout[l:i] = {}
		call setline(l:i , join(l:word[l:i] , ' '))
		for l:j in range(len(l:word[l:i]))
			"let l:len = len(l:word[l:i][l:j]) + 1
			let l:len = s:displaylen(l:word[l:i][l:j]) + 1
			let l:index = 1 + len(join(l:word[l:i][0:(l:j)] , ' ')) - l:len + 1
			let l:layout[l:i][l:j] = {
				\ 'len'  : l:len - 1 ,
				\ 'index' : l:index ,
				\ 'type' : synID(l:i , l:index , 1)
			\ }
		endfor
		call setline(l:i , l:indent . getline(l:i))
	endfor
	return l:layout
endfunction
function! s:apply_line_layout() range
	let l:word = {}
	let l:layout = s:get_line_layout()
	let l:align = {}
	for l:i in range(line("'<") , line("'>"))
		for l:j in range(len(l:layout[l:i]))
			if !(has_key(l:align , l:j))
				let l:align[l:j] = 0
			endif
			let l:align[l:j] = max([l:align[l:j] , l:layout[l:i][l:j]['len']])
		endfor
	endfor
	for l:i in range(line("'<") , line("'>"))
		let l:indent = strpart(getline(l:i) , 0 , match(getline(l:i) , '\S'))
		let l:word[l:i] = split(getline(l:i) , '')
		for l:j in range(len(l:align))
			if (len(l:word[l:i]) - 1) > l:j
				let l:word[l:i][l:j] = l:word[l:i][l:j] . repeat(' ' , l:align[l:j] - len(l:word[l:i][l:j]))
			endif
		endfor
		call setline(l:i , l:indent . join(l:word[l:i] , ' '))
	endfor
endfunction
command! -range Vsqueeze '<,'> call s:get_line_layout()
command! -range Valign '<,'> call s:apply_line_layout()
