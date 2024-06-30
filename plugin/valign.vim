function! s:displaylen(str)
	"only for Chinese, sc. 3B/character
	let l:len = len(a:str)
	let l:chars = strchars(a:str)
	let l:offset = (len(a:str) - strchars(a:str))/2
	return l:len - l:offset
endfunction
function! s:get_line_layout(undo) range
	let l:layout = {}
	let l:layout['len'] = {}
	let l:layout['index'] = {}
	let l:layout['type'] = {}
	let l:layout['word'] = {}
	for l:i in range(line("'<") , line("'>"))
		let l:indent = strpart(getline(l:i) , 0 , match(getline(l:i) , '\S'))
		let l:layout['word'][l:i] = split(getline(l:i) , '')
		call setline(l:i , join(l:layout['word'][l:i] , ' '))
		let l:layout['len'][l:i] = []
		let l:layout['index'][l:i] = []
		let l:layout['type'][l:i] = []
		for l:j in range(len(l:layout['word'][l:i]))
			"let l:len = len(l:layout['word'][l:i][l:j]) + 1
			let l:len = s:displaylen(l:layout['word'][l:i][l:j]) + 1
			let l:index = 1 + len(join(l:layout['word'][l:i][0:(l:j)] , ' ')) - l:len + 1
			call add(l:layout['len'][l:i] , l:len - 1)
			call add(l:layout['index'][l:i] , l:index)
			call add(l:layout['type'][l:i] , synID(l:i , l:index , 1))
		endfor
		if a:undo
			normal! u
		else
			call setline(l:i , l:indent . getline(l:i))
		endif
	endfor
	return l:layout
endfunction
function! s:apply_line_layout(layout) range
	let l:align = {}
	for l:i in range(line("'<") , line("'>"))
		for l:j in range(len(a:layout['len'][l:i]))
			if !(has_key(l:align , l:j))
				let l:align[l:j] = 0
			endif
			let l:align[l:j] = max([l:align[l:j] , a:layout['len'][l:i][l:j]])
		endfor
	endfor
	for l:i in range(line("'<") , line("'>"))
		let l:indent = strpart(getline(l:i) , 0 , match(getline(l:i) , '\S'))
		let l:word = a:layout['word'][l:i]
		for l:j in range(len(l:align))
			if (len(l:word) - 1) > l:j
				let l:word[l:j] = l:word[l:j] . repeat(' ' , l:align[l:j] - len(l:word[l:j]))
			endif
		endfor
		call setline(l:i , l:indent . join(l:word , ' '))
	endfor
endfunction
function! s:syntax0layout(layout) range
	let l:layout = { 'len' : {} , 'word' : {} }
	for l:i in range(line("'<") , line("'>"))
		let l:layout['word'][l:i] = []
		let l:layout['len'][l:i] = []
		let l:word = split(getline(l:i) , '')
		let l:index0 = []
		call map(a:layout['type'][l:i] , 'v:val!=0')
		call add(l:layout['word'][l:i] , '')
		let l:flag = a:layout['type'][l:i][0]
		for l:j in range(len(a:layout['type'][l:i]))
			if a:layout['type'][l:i][l:j]==l:flag
				let l:layout['word'][l:i][-1] = trim(l:layout['word'][l:i][-1] . ' ' . l:word[l:j])
			else
				call add(l:layout['word'][l:i] , l:word[l:j])
				let l:flag = !l:flag
			endif
		endfor
		let l:layout['len'][l:i] = mapnew(l:layout['word'][l:i] , 'len(v:val)')
	endfor
	return l:layout
endfunction
command! -range Vsqueeze '<,'> call s:get_line_layout(v:false)
command! -range Valign '<,'> call s:apply_line_layout(s:get_line_layout(v:false))
command! -range Vsyntax0 '<,'> call s:apply_line_layout(s:syntax0layout(s:get_line_layout(v:false)))
