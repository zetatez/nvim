" |_   _|__   |  _ \ ___ (_) ___ (_) ___ __
"   | |/ _ \  | |_) / _ \| |/ _ \| |/ __/ _ \
"   | | (_) | |  _ <  __/| | (_) | | (_|  __/
"   |_|\___/  |_| \_\___|/ |\___/|_|\___\___|
"                      |__/
" :source snapshot.vim to recover
" or execute: vim -S snapshot.vim

" nvimrc
" Author: @lorenzo

""""""
"""""" auto load for first time uses
if empty(glob('~/.nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

""""""
"""""" required
let g:python3_host_prog = '/usr/local/bin/python3'

""""""
"""""" alway keep a backup
silent! exec "!cp -f ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bk"

"""""" backup
silent !mkdir -p ~/.nvim/tmp/backup
silent !mkdir -p ~/.nvim/tmp/undo
" silent !mkdir -p ~/.vim/tmp/sessions
set backupdir=~/.nvim/tmp/backup,.
set directory=~/.nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=~/.nvim/tmp/undo,.
endif
" set colorcolumn=120
set updatetime=100                               " when nothing is typed, the swap file will be written to disk
set virtualedit=block
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""
"""""" TOP
set nocompatible
let mapleader="\<SPACE>"

"-------------------------------------------------------
" |   vim-plug start        flag=f1                    |
"-------------------------------------------------------
" configure vim, make it's build in plug-ins loadable
filetype plugin on
call plug#begin('~/.nvim/plugged')
""""""
"""""" terminal
Plug 'voldikss/vim-floaterm'
" Plug 'LoricAndre/fzterm.nvim'

""""""
"""""" treesitter
if has("nvim")
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/playground'
endif

""""""
"""""" general highlighter
if has("nvim")
    Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
    Plug 'RRethy/vim-illuminate'
    let g:Illuminate_delay = 750
    hi illuminatedWord cterm=undercurl gui=undercurl
endif

Plug 'mhinz/vim-startify'
Plug '907th/vim-auto-save'

""""""
"""""" secret
Plug 'ernstwi/vim-secret'
" :sectet  to enter secret mode
" :Secret (line | word | char | none)
" :sectet! to exit secret mode

""""""
"""""" calendar
Plug 'itchyny/calendar.vim'
let g:calendar_views= ['clock', 'year', 'month', 'day_7', 'day', 'agenda', 'event']
let g:calendar_cyclic_view=1
let g:calendar_skip_event_delete_confirm=1
let g:calendar_skip_task_delete_confirm=1
let g:calendar_skip_task_clear_completed_confirm=1
let g:calendar_google_calendar = 0
let g:calendar_google_task = 0
noremap \\ :Calendar -view=clock -position=here<CR>
noremap <C-X> :Calendar -view=month<CR>
nnoremap fc :Calendar <CR>
cnoremap cd Calendar -view=day<CR>
cnoremap cw Calendar -view=week<CR>
cnoremap cm Calendar -view=month<CR>

""""""
"""""" ranger
Plug 'francoiscabrol/ranger.vim'
let g:ranger_map_keys = 0
let g:NERDTreeHijackNetrw = 0
let g:ranger_replace_netrw = 0
nnoremap <LEADER>R :RangerNewTab<CR>


""""""
"""""" tmux
Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_save_on_switch = 2
let g:tmux_navigator_disable_when_zoomed = 1
" <ctrl-h> => Left
" <ctrl-j> => Down
" <ctrl-k> => Up
" <ctrl-l> => Right
" <ctrl-\> => Previous split

""""""
"""""" file navigation
Plug 'preservim/nerdtree'
let NERDTreeShowHidden=1
let NERDTreeWinSize=20
let NERDTreeIgnore=['\.git$','\.swp$','\.DS_Store$']
let g:DTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = '/'
autocmd StdinReadPre * let s:std_in=1
" open a nerdtree automatically when vim starts up if no files were specified
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" do not open, or can not use startify
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif  " close vim when only nerdtree left

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'majutsushi/tagbar'
nnoremap \] :TagbarToggle<CR>

"""""
""""" taglist
Plug 'liuchengxu/vista.vim'

""""""
"""""" file manager
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<LEADER>p'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
set rtp+=/home/lorenzo
nnoremap <LEADER>f :Files ~<CR>
" CTRL-T  -- open selected files in current window
" CTRL-X  -- open selected files in new tabs
" CTRL-V  -- open selected files in vs split

Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

Plug 'kevinhwang91/rnvimr'
let g:rnvimr_ex_enable = 1
let g:rnvimr_pick_enable = 1
let g:rnvimr_draw_border = 0
let g:rnvimr_bw_enable = 1
highlight link RnvimrNormal CursorLine
let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
            \ }
let g:rnvimr_layout = { 'relative': 'editor',
            \ 'width': &columns,
            \ 'height': &lines,
            \ 'col': 0,
            \ 'row': 0,
            \ 'style': 'minimal' }
let g:rnvimr_presets = [{'width': 1.0, 'height': 1.0}]

Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['__vim_project_root', '.git/']
let g:rooter_silent_chdir = 1

Plug 'pechorin/any-jump.vim'
let g:any_jump_window_width_ratio  = 0.8
let g:any_jump_window_height_ratio = 0.9

""""""
"""""" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#formatter = 'default''
let g:airline_theme= 'transparent'

Plug 'theniceboy/eleline.vim'
Plug 'ojroques/vim-scrollstatus'

""""""
"""""" interesting words
Plug 'lfv89/vim-interestingwords'
nnoremap <silent> <LEADER>k :call InterestingWords('n')<cr>
nnoremap <silent> <LEADER>l :call UncolorAllWords()<cr>
nnoremap <silent> n :call wordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>

"""""" !!!
"""""" multi editing :help visual-multi
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'wellle/targets.vim'


"""""" !!!
"""""" ctrl-a/ctrl-x to decrease or increase date, time and more
Plug 'tpope/vim-speeddating'

""""""
"""""" wildfire and surround
Plug 'gcmt/wildfire.vim'

"""""" !!!
"""""" vim-surround
Plug 'tpope/vim-surround'

""""""
"""""" repeat
Plug 'tpope/vim-repeat'

""""""
"""""" incsearch
Plug 'haya14busa/incsearch.vim'

""""""
"""""" sneak is a powerful, reliable, yet minimal motion plugin for vim
Plug 'justinmk/vim-sneak'

""""""
"""""" find & replace
Plug 'brooth/far.vim'
Plug 'osyo-manga/vim-anzu'
Plug 'mileszs/ack.vim'

Plug 'tpope/vim-abolish'

"""""" !!!
"""""" vim-commentary
Plug 'tpope/vim-commentary'

"""""" !!!
"""""" :h tabular
Plug 'godlygeek/tabular'
" :Tabularize /=<CR>
vnoremap tt :Tabularize /
" note: visual mode and normal mode not confilct

""""""
"""""" pair parentheses
Plug 'kien/rainbow_parentheses.vim'
let g:rbpt_colorpairs = [
      \ ['brown',       'RoyalBlue3'  ],
      \ ['Darkblue',    'SeaGreen3'   ],
      \ ['darkgray',    'DarkOrchid3' ],
      \ ['darkgreen',   'firebrick3'  ],
      \ ['darkcyan',    'RoyalBlue3'  ],
      \ ['darkred',     'SeaGreen3'   ],
      \ ['darkmagenta', 'DarkOrchid3' ],
      \ ['brown',       'firebrick3'  ],
      \ ['gray',        'RoyalBlue3'  ],
      \ ['darkmagenta', 'DarkOrchid3' ],
      \ ['Darkblue',    'firebrick3'  ],
      \ ['darkgreen',   'RoyalBlue3'  ],
      \ ['darkcyan',    'SeaGreen3'   ],
      \ ['darkred',     'DarkOrchid3' ],
      \ ['red',         'firebrick3'  ],
      \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
" Always On:
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces

""""""
"""""" snippets
Plug 'SirVer/ultisnips'
" Trigger configuration. You need to change this to something other than <\> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger = '<TAB>'
let g:UltiSnipsJumpForwardTrigger = '<C-J>'
let g:UltiSnipsJumpBackwardTrigger = '<C-K>'
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetDirectories = ['~/macos.cfg/.ultisnips/']

nnoremap <LEADER>; :UltiSnipsEdit<CR><C-W>H 
inoremap <LEADER>; <ESC>:UltiSnipsEdit<CR><C-W>H

Plug 'honza/vim-snippets'

" Plug 'theniceboy/vim-snippets'

""""""
"""""" language xkbswitch: it make vim very slow, better not use
" git clone git@github.com:lyokha/vim-xkbswitch.git
" cp vim-xkbswitch/bin/xkbswitch  /usr/local/bin/
" git clone git@github.com:myshov/libxkbswitch-macosx.git
" cp libxkbswitch-macosx/bin/libxkbswitch.dylib /usr/local/lib/
" Plug 'lyokha/vim-xkbswitch'
" let g:XkbSwitchEnabled = 1
" inoremap 健康 <ESC>

""""""
"""""" colorschema
if has("nvim")
    Plug 'theniceboy/nvim-deus'
endif
" Plug 'arzg/vim-colors-xcode'

Plug 'morhetz/gruvbox'
Plug 'flazz/vim-colorschemes'
Plug 'altercation/vim-colors-solarized'

""""""
"""""" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
let g:gitgutter_signs = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
autocmd BufWritePost * GitGutter

Plug 'theniceboy/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] }
Plug 'fszymanski/fzf-gitignore', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'cohama/agit.vim'
Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
Plug 'junegunn/gv.vim'

Plug 'kdheepak/lazygit.nvim'
noremap <LEADER>G :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0
let g:lazygit_floating_window_scaling_factor = 1.0
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯']
let g:lazygit_use_neovim_remote = 1 " for neovim-remote support

""""""
"""""" undotree: ": shift + '
Plug 'mbbill/undotree'
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
noremap ZZ <nop>
noremap Z :UndotreeToggle<CR>

""""""
"""""" general writing
Plug 'reedes/vim-wordy'
Plug 'ron89/thesaurus_query.vim'
" Plug 'reedes/vim-pencil'

""""""
"""""" bookmarks
Plug 'kshenoy/vim-signature'

""""""
"""""" lang
" Plug 'sheerun/vim-polyglot'
Plug 'thinca/vim-quickrun'

""""""
"""""" syntax checking
" need to install flake8: pip install flake8
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 3
let g:syntastic_python_checkers = ['python']

""""""
"""""" bash
Plug 'vim-scripts/bash-support.vim'

"""""" c++
""""""
Plug 'rip-rip/clang_complete'
Plug 'octol/vim-cpp-enhanced-highlight'

""""""
"""""" scala
Plug 'derekwyatt/vim-scala'

""""""
"""""" julia
Plug 'julialang/julia-vim'

""""""
"""""" go
Plug 'dgryski/vim-godef'
let g:godef_split=2

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" :GoUpdateBinaries
" :GoInstallBinaries
let g:go_fmt_command = "goimports"
" let g:go_snippet_engine = "ultisnips"
" prevent integrated ultisnips
let g:go_snippet_engine = 0
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_version_warning = 1
let g:go_doc_popup_window = 1
let g:go_def_mapping_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 0
let g:go_auto_type_info = 1
let g:go_def_mapping_enabled = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_variable_declarations = 0
let g:go_doc_keywordprg_enabled = 0

cnoremap gr !clear; go run %<CR>
cnoremap gb !clear; go build %<CR><CR>
cnoremap gh term go doc 
cnoremap gi GoImport 
cnoremap gr GoDrop 
cnoremap gl GoLint
cnoremap gc GoVet
cnoremap ga GoAlternate

" go get -u golang.org/x/lint/golint
Plug 'golang/lint'

""""""
"""""" python
Plug 'hdima/python-syntax'
Plug 'google/yapf'
Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] }

if has("nvim")
    Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for' :['python', 'vim-plug'] }
endif

" Plug 'tmhedberg/SimpylFold', { 'for' :['python', 'vim-plug'] }
" Plug 'vim-scripts/indentpython.vim', { 'for' :['python', 'vim-plug'] }
Plug 'plytophogy/vim-virtualenv', { 'for' :['python', 'vim-plug'] }
Plug 'ivanov/vim-ipython'
Plug 'sillybun/autoformatpythonstatement'
autocmd FileType python let g:autoformatpython_enabled = 1

""""""
"""""" csharp
Plug 'OmniSharp/omnisharp-vim'
let g:OmniSharp_typeLookupInPreview = 1
let g:omnicomplete_fetch_full_documentation = 1
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'ctrlp'

""""""
"""""" swift
Plug 'keith/swift.vim'
Plug 'arzg/vim-swift'

""""""
"""""" xml, css, html, css, php, etc.
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'
Plug 'othree/xml.vim'
Plug 'ap/vim-css-color'
Plug 'hail2u/vim-css3-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'alvan/vim-closetag'
" Plug 'hail2u/vim-css3-syntax' " , { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
" Plug 'spf13/PIV', { 'for' :['php', 'vim-plug'] }
" Plug 'pangloss/vim-javascript', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
" Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
" Plug 'jelera/vim-javascript-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
"Plug 'jaxbot/browserlink.vim'
Plug 'HerringtonDarkholme/yats.vim'
" Plug 'posva/vim-vue'
" Plug 'evanleck/vim-svelte', {'branch': 'main'}
" Plug 'leafOfTree/vim-svelte-plugin'
" Plug 'leafgarland/typescript-vim'

""""""
"""""" javascript
Plug 'pangloss/vim-javascript', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }

""""""
"""""" tex
Plug 'lervag/vimtex'                                                    " latex
let g:tex_flavor='latex'
let g:vimtex_view_method='skim'
let g:vimtex_quickfix_mode=0
let g:vimtex_compiler_latexmk = {
      \ 'executable' : 'latexmk',
      \ 'options' : [
      \   '-xelatex',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

" Plug 'KeitaNakamura/tex-conceal.vim'
" set conceallevel=1
" set conceallevel=0
" let g:tex_conceal='abdmg'

""""""
"""""" markdown
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1

Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown'] }
let g:vmt_auto_update_on_save = 0
let g:vmt_dont_insert_fence = 1
let g:vmt_cycle_list_item_markers = 1
let g:vmt_fence_text = 'TOC'
let g:vmt_fence_closing_text = '/TOC'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
let g:mkdp_path_to_chrome = "/Applications/Safari.app"
let g:mkdp_markdown_css=''

Plug 'junegunn/goyo.vim'
let g:goyo_width=150
let g:goyo_height=85
nnoremap gh :Goyo<CR> 

Plug 'dkarter/bullets.vim'
let g:bullets_set_mappings = 0
let g:bullets_enabled_file_types = [
      \ 'markdown',
      \ 'text',
      \ 'gitcommit',
      \ 'scratch'
      \]

Plug 'theniceboy/bullets.vim'

Plug 'ferrine/md-img-paste.vim'
let g:mdip_imgdir = 'pic'
let g:mdip_imgname = 'image'

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
let g:instant_markdown_slow = 0
let g:instant_markdown_autostart = 0
" let g:instant_markdown_open_to_the_world = 1
" let g:instant_markdown_allow_unsafe_content = 1
" let g:instant_markdown_allow_external_content = 0
" let g:instant_markdown_mathjax = 1
let g:instant_markdown_autoscroll = 1

Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
noremap <LEADER>tm :TableModeToggle<CR>

""""""
"""""" docker
Plug 'ekalinin/dockerfile.vim'
Plug 'kevinhui/vim-docker-tools'


""""""
"""""" json
" Plug 'elzr/vim-json'
" Plug 'neoclide/jsonc.vim'

""""""
"""""" csv
Plug 'chrisbra/csv.vim'

""""""
"""""" pdf: vi filename.pdf
Plug 'makerj/vim-pdf'

""""""
"""""" Editor Enhancement
Plug 'Raimondi/delimitMate'
Plug 'jiangmiao/auto-pairs'

Plug 'theniceboy/antovim'

Plug 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_do_shade = 0
let g:EasyMotion_smartcase = 1

Plug 'Konfekt/FastFold'

Plug 'junegunn/vim-peekaboo'

Plug 'wellle/context.vim'

Plug 'svermeulen/vim-subversive'

Plug 'theniceboy/argtextobj.vim'

Plug 'rhysd/clever-f.vim'

Plug 'AndrewRadev/splitjoin.vim'

Plug 'theniceboy/pair-maker.vim'

Plug 'theniceboy/vim-move'

Plug 'jeffkreeftmeijer/vim-numbertoggle'

""""""
"""""" formatter
" need to install autopep8: pip install autopep8
Plug 'Chiel92/vim-autoformat'
nnoremap \f :Autoformat<CR>
let g:autoformat_autoindent = 1
let g:autoformat_rtab = 0
let g:autoformat_remove_trailing_spaces = 1

Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'

""""""
"""""" debug
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-go --enable-bash --enable-python'}
let g:vimspector_enable_mappings = 'HUMAN'
function! s:read_template_into_buffer(template)
	" has to be a function to avoid the extra space fzf#run insers otherwise
	execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
			\   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
			\   'down': 20,
			\   'sink': function('<sid>read_template_into_buffer')
			\ })
" noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
sign define vimspectorBP text=☛ texthl=Normal
sign define vimspectorBPDisabled text=☞ texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBad

" F5           <Plug>VimspectorContinue
" F3           <Plug>VimspectorStop
" F4           <Plug>VimspectorRestart
" F6           <Plug>VimspectorPause
" F9           <Plug>VimspectorToggleBreakpoint
" <leader>F9   <Plug>VimspectorToggleConditionalBreakpoint
" F8           <Plug>VimspectorAddFunctionBreakpoint
" <leader>F8   <Plug>VimspectorRunToCursor
" F10          <Plug>VimspectorStepOver
" F11          <Plug>VimspectorStepInto
" F12          <Plug>VimspectorStepOut

" go lang debuger
" go get -u github.com/go-delve/delve/cmd/dlv

" python lang debuger
" pip install debugpy

""""""
"""""" auto complete
Plug 'codota/tabnine-vim'
Plug 'wellle/tmux-complete.vim'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" CocInstall coc-json coc-tsserver
" CocConfig

""""""
""""""" for general writing
Plug 'reedes/vim-wordy'
Plug 'ron89/thesaurus_query.vim'

""""""
"""""" bookmarks
Plug 'MattesGroeger/vim-bookmarks'

""""""
"""""" find & replace
Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Fardo'] }

""""""
"""""" documentation
Plug 'kabbamine/zeavim.vim'

""""""
"""""" mini vim-app
Plug 'mhinz/vim-startify'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

""""""
"""""" other visual enhancement
Plug 'luochen1990/rainbow'

Plug 'mg979/vim-xtabline'
let g:xtabline_settings = {}
let g:xtabline_settings.enable_mappings = 0
let g:xtabline_settings.tabline_modes = ['tabs', 'buffers']
let g:xtabline_settings.enable_persistance = 0
let g:xtabline_settings.last_open_first = 1
noremap to :XTabCycleMode<CR>
noremap \p :echo expand('%:p')<CR>

" need nerd-font
" brew tap homebrew/cask-fonts
" brew install font-hack-nerd-font --cask
Plug 'ryanoasis/vim-devicons'
Plug 'wincent/terminus'

""""""
"""""" other useful utilities
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'

""""""
"""""" dependencies
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'kana/vim-textobj-user'
Plug 'roxma/nvim-yarp'

call plug#end()
"-------------------------------------------------------
" :w
" :source %
" :PlugInstall
" :q
"-------------------------------------------------------
" |   vim-plug end                                     |
"-------------------------------------------------------



"-------------------------------------------------------
" |   basic start           flag=f2                   |
"-------------------------------------------------------
" :h option-list        show all parameters that can be configured
" :set <parameter>?     show current status of the parameter
" :set <parameter>&     reset parameter to default value

""""""
"""""" system
" set clipboard=unnamedplus
let &t_ut=''
set autochdir

""""""
"""""" Editor Behavior
scriptencoding utf-8
set secure
set exrc
set encoding=utf-8
set maxmempattern=8000
set history=10000
" set autochdir
set autowrite
set nowrap
set mousehide
set hidden
set wildmenu
set wildmode=full
" set spell
" set spellang=en_us
set nowrap
set number
" set paste                                     " do set, or jk eas map will not work
set relativenumber
set ruler
" set cursorcolumn
set cursorline
" set foldenable
set foldmethod=indent
set foldlevel=99
set foldenable
" set nofoldenable
set bufhidden=hide
set hls
set incsearch
set showmatch
set noshowmode
set showcmd
set list
set listchars=tab:\.\ ,trail:<
set viewoptions=cursor,folds,slash,unix
set textwidth=0
set splitright
set splitbelow
set indentexpr=
set formatoptions-=tc
set shortmess+=c
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast
set lazyredraw
set visualbell
set backspace=2
set scrolloff=3
set path=.,/usr/include                         " directories which will be searched when using: gf, [f, ]f, ^Wf, :find, :sfind, :tabfind...
syntax on

let g:session_autoload = 'no'

""""""
"""""" terminal behaviors
let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#FF5555'
let g:terminal_color_2  = '#50FA7B'
let g:terminal_color_3  = '#F1FA8C'
let g:terminal_color_4  = '#BD93F9'
let g:terminal_color_5  = '#FF79C6'
let g:terminal_color_6  = '#8BE9FD'
let g:terminal_color_7  = '#BFBFBF'
let g:terminal_color_8  = '#4D4D4D'
let g:terminal_color_9  = '#FF6E67'
let g:terminal_color_10 = '#5AF78E'
let g:terminal_color_11 = '#F4F99D'
let g:terminal_color_12 = '#CAA9FA'
let g:terminal_color_13 = '#FF92D0'
let g:terminal_color_14 = '#9AEDFE'

""""""
"""""" auto change directory to current dir
autocmd BufEnter * silent! lcd %:p:h

""""""
"""""" color
" colorscheme pencil
" colorscheme github
" colorscheme Chasing_Logic
colorscheme sift

""""""
"""""" space style for different language
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent

""""""
"""""" always back to the last cursor
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

""""""
"""""" map <Esc> as jk in inerst mode. Note: if set paste jk will be invalid
" do not map in norm mode, it will low down the jk speed
inoremap jk <ESC>

""""""
"""""" <ESC> and jk kj
" map <ESC>: as kj in insert mode
" map <ESC>: as ik in cmd mode
" inoremap kj <ESC>:
" nnoremap kj <ESC>: 
" cnoremap jk <ESC>
" then you can try kj in inerst mode, kj in cmd mode

""""""
"""""" exchange : and ; in normal mode
" note: do not use nmap : ;, when use f jumps from char, ; will not performance will
nnoremap ; :
nnoremap : ;

""""""
"""""" zen mode
noremap <C-c> zz
" Ctrl + U or D will move up/down the view port without moving the cursor
noremap <C-u> 5<C-y>
noremap <C-d> 5<C-e>

""""""
"""""" :term
noremap <LEADER>t :set splitbelow<CR>:split<CR>:res +10<CR>:term<CR>

""""""
"""""" tab
nnoremap tt :tabnew<CR>
nnoremap to :tabonly<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>

""""""
"""""" :bn :bp
noremap <LEADER>, <ESC>:bn<CR>
noremap <LEADER>. <ESC>:bp<CR>

""""""
"""""" pane split, save, quit
" disable the default s key
noremap s <nop>

"""""" split the screens to up (horizontal), down (horizontal), left (vertical), right (vertical)
noremap sj :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sk :set splitbelow<CR>:split<CR>
noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap sl :set splitright<CR>:vsplit<CR>

""""""" place the two screens up and down, place the two screens side by side
noremap s- <C-w>t<C-w>K
noremap s= <C-w>t<C-w>H

"""""" rotate screens
noremap s, <C-w>b<C-w>K
noremap s. <C-w>b<C-w>H

"""""" jump from panes
noremap <C-h>  <C-w><C-h>
noremap <C-j>  <C-w><C-j>
noremap <C-k>  <C-w><C-k>
noremap <C-l>  <C-w><C-l>

"""""" resize pane
noremap <up> :res +3<CR>
noremap <down> :res -3<CR>
noremap <left> :vertical resize+3<CR>
noremap <right> :vertical resize-3<CR>

"""""" quit, svae, exchange pane
nnoremap <LEADER>q <C-w>j:q<CR>
nnoremap <LEADER>w :w<CR>
nnoremap <LEADER>e <ESC><C-w>x<CR>

""""""
"""""" command mode cursor movement
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-b> <S-Left>
cnoremap <C-w> <S-Right>

""""""
"""""" insert mode cursor movement
inoremap <C-E> <ESC>A
inoremap <C-B> <ESC>I
inoremap <C-L> <ESC>ddi
inoremap <C-D> <ESC>lDA

""""""
"""""" sudo write
cnoremap ww w !sudo tee % >/dev/null

""""""
"""""" overwrite goto file
" map gf :vs <cfile><CR>

nnoremap <LEADER><LEADER> <ESC>n

""""""
"""""" map y$ to Y
nnoremap Y y$

""""""
"""""" copy to system clipboard
vnoremap Y "+y

""""""
"""""" indentation
noremap < <<
noremap > >>
vnoremap < <<<ESC>gv
vnoremap > >><ESC>gv

""""""
"""""" block move
noremap Q dd2kp
noremap S ddp
" vnoremap Q d2kp<ESC>
" vnoremap S dp<ESC>

""""""
"""""" searching
noremap - N
noremap = n

""""""
"""""" acceleration
" ttimeoutlen    mapping delay      key code delay
"    < 0        'timeoutlen'       'timeoutlen'
"   >= 0        'timeoutlen'       'ttimeoutlen'        *
set timeoutlen=400
set ttimeoutlen=0

" faster in-line navigation
noremap W 5w
noremap B 5b

" fast move to 0 and $
noremap ( <ESC>0
noremap ) <ESC>$

""""""
"""""" see changes
function! DiffWithFileFromDisk()
    let filename=expand('%')
    let diffname = filename.'.fileFromBuffer'
    exec 'saveas! '.diffname
    diffthis
    vsplit
    exec 'edit '.filename
    diffthis
endfunction
nmap \d :call DiffWithFileFromDisk()<CR>

""""""
"""""" build ctags for go to definition, you can add your project folder at any time
set tags=~/tags
noremap \t :!nohup ctags -R . >> /dev/null 2>&1 &<CR><CR>
" C-]         " go to definition
" C-T         " back

""""""
""""""" find and replace
noremap \s :%s/<C-r><C--w>/g<left><left>

""""""
"""""" find duplicate words, duplicate lines. it's bravo !
cnoremap dw /\(\<\w\+\>\) *\1\>
cnoremap dl /^\(.\+\)$\n\1$

""""""
"""""" set wrap
noremap <LEADER>sw :set wrap<CR>

""""""
"""""" spell check
noremap <LEADER>sc :set spell!<CR>
noremap <LEADER>sn :set nospell!<CR>

""""""
"""""" clever tab
function! CleverTab()
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-N>"
  endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

""""""
"""""" automatically expand current file folder with %%
cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'
" try
" :vs %%
" will expand to
" :vs ./

"auto spell
autocmd BufRead,BufNewFile *.md setlocal spell

""""""
"""""" press f10 to show hlgroup
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
map <F10> :call SynGroup()<CR>

"""""
""""" compile and run: c/c++/python/shell
nnoremap <LEADER>b :call CompileRun()<CR>
func! CompileRun()
    exec "w"
    if &filetype == 'c'
        exec '!g++ % -o %<'
        exec '!time ./%<'
    elseif &filetype == 'cpp'
        set splitbelow
        exec "!g++ -std=c++11 % -Wall -o %<"
        set splitbelow
        :term ./%<
    elseif &filetype == 'go'
        set splitbelow
        :term go run %
    elseif &filetype == 'python'
        set splitbelow
        :term time python %
    elseif &filetype == 'julia'
        set splitbelow
        :term time julia %
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        exec '!time bash %'
    elseif &filetype == 'markdown'
        exec "InstantMarkdownPreview"
    elseif &filetype == 'html'
        silent! exec "!".g:mkdp_browser." % &"
    elseif &filetype == 'javascript'
        set splitbelow
        :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
    endif
endfunc

""""""
"""""" for tex, open pdf with zathura in current folder
noremap \lp :! zathura *pdf >> /dev/null 2>&1 &<CR><CR>

""""""
""""""  vimrc zshrc
nnoremap ,. :vs ~/.vimrc<CR>
nnoremap ., <ESC>:update<CR>:source ~/.vimrc<CR>
inoremap ., <ESC>:update<CR>:source ~/.vimrc<CR>

nnoremap .z :Vs ~/.zshrc<CR>
nnoremap z. <ESC>:!source ~/.zshrc<CR><CR><CR>
inoremap z. <ESC>:!source ~/.zshrc<CR><CR><CR>

""""""
"""""" to cmds
nnoremap te :!
nnoremap tr :r!
nnoremap ty <ESC>yyq:p<ESC>Ir! <ESC>A<CR><ESC>:w<CR><ESC>o<ESC>j
nnoremap tf :r !figlet 

""""""
"""""" lower/upper current line
noremap tu <S-v>gu
noremap ti <S-v>gU

""""""
"""""" upper the firt char of the current word
noremap <C-Q> vawbgUw
inoremap <C-Q> <ESC>vawbgUw

""""""
"""""" terminal
nnoremap <LEADER>t :ter<CR><CR><C-w>J

""""""
"""""" space to tab
cnoremap st :%s/    /\t/g
cnoremap ts :%s/\t/    /g

""""""
"""""" search current word
nnoremap <C-S> /<C-R><C-W>

""""""
"""""" folding
noremap <silent> <LEADER>o za

""""""
"""""" lazygit
nnoremap <C-G> :!clear; lazygit<CR><CR>

""""""
"""""" weather
nnoremap <C-W> :!clear; curl wttr.in/shanghai; finger shanghai@graph.no<CR>

""""""
"""""" for taskwarrior
" brew install task
nnoremap <C-T> :! clear; task summary; task ghistory; tark burndown.daily; task calendar <CR>
cnoremap tk ! clear; task 
cnoremap ;a ! clear; task add 
cnoremap ;p ! clear; task project:
cnoremap ;e ! clear; task edit 
cnoremap ;m ! clear; task modify 
cnoremap ;l ! clear; task list<CR>
cnoremap ;n ! clear; task next<CR>
cnoremap ;t ! clear; task due:today list<CR>
cnoremap ;d ! clear; task due.any: list<CR>
cnoremap ;[ ! clear; task start 
cnoremap ;] ! clear; task stop 
cnoremap ;r ! clear; task ready 
cnoremap ;i ! clear; task waiting 
cnoremap ;o ! clear; task reports <CR>
"ts:summary
cnoremap ;s ! clear; task summary; task ghistory; tark burndown.daily; task calendar <CR>
"tf:filter
cnoremap ;f ! clear; echo "task project:home and -work status:pending /pattern/ list"; task 
"t1:template
cnoremap ;1 ! clear; echo "task add Send Alice a birthday card due:2016-11-08 scheduled:due-4d wait:due-7d until:due+2d"; task add 

""""""
"""""" for timewarrior
" brew install timewarrior
nnoremap <LEADER>z :!clear; timew month<CR>
cnoremap tw ! clear; timew 
cnoremap 'd ! clear; timew day<CR>
cnoremap 'w ! clear; timew week<CR>
cnoremap 'm ! clear; timew month<CR>

""""""
"""""" use <LEADER><CR> to remove the highlight after search
nnoremap <LEADER>n :let @/ = ""<CR>:<BACKSPACE>

"-------------------------------------------------------
" |   basic end                                        |
"-------------------------------------------------------

"-------------------------------------------------------
" |   skills                flag=f3                    |
"-------------------------------------------------------
"""""" tips
" /\v({}[]                                                              " pattern:very magiv mode, regular expression will more like python, ()[]{} will no need \!
" v enter visual mode, then /search !!!                                 " show current edit filename and status
" C-g                                                                   " show current edit filename and status
" f                                                                     " jump from chars. ; forward. , backward
" :r ! ls -la                                                           " read any exec result from shell
" :earlier 15m                                                          " restore file to 15 min ago
" :saveas filename                                                      " save current file as a new file
" :tabdo %s/foo/bar/g                                                   " refactor
" gUiw/guiw                                                             " switch case of the current word

"""""" cmd editing window: history! search history !!! very powerful
" q:
" q/
" when in cmd mode use <C-f> to open cmd editor window

" useage 1: paste your cmds from current editing file to cmd editing window, and read cmd results to current editing file
" ls -l
" esc
" I r!: r! ls -l
" esc
" yy to copy: r! ls -l
" q:p<CR>

"""""" insert mode
" C-o                                                                   ” execute one command, return to Insert mode
" C-r                                                                   ” insert the contents os a register: 0-9a-z"%#*+:.-=
" C-h                                                                   " del a char
" C-w                                                                   " del a word
" C-u                                                                   ” del to ^
" C-m                                                                   ” begin a new line
" C-i                                                                   ” insert a tab
" C-t                                                                   ” add    indent current line
" C-d                                                                   ” delete indent current line
" C-n                                                                   ” complete word next
" C-p                                                                   ” complete word previous

"""""" completion
" C-x C-l                                                               " complete the whole line
" C-x C-n                                                               " complete word form current buffer
" C-x C-k                                                               " complete word form directory
" C-x C-t                                                               " complete synonym
" C-x C-i                                                               " complete word form current file and include files

"""""" foldenable
" zc                                                                    " close a fold
" zo                                                                    " open  a fold
" zM                                                                    " close all fold
" zR                                                                    " open  all fold

"""""" bookmarks
" mm                                                                    " mark with m
" `m                                                                    " goto mark m
" 'm                                                                    " goto mark m
" `"                                                                    " to the position where you did last edit before exit
" '<                                                                    " to the first line of previously selected visual area
" '>                                                                    " to the last line of previously selected visual area
" '.                                                                    " to the position of where the last change was made
" `[                                                                    " to the first character of previously changed or yanked text
" `]                                                                    " to the last character of previously changed or yanked text
" '^                                                                    " to the position where the cursor was the last time when insert mode was stopped

"""""" search pattern1 change to pattern2
" /pattern1<CR>
" c/pattern2/e<CR>
" new contents<ESC>

""""" search word, change it to a new word, jump next
" /word<CR>
" c//e<CR>
" new word<ESC>
" //<CR>

"-------------------------------------------------------
" |   skills end                                       |
"-------------------------------------------------------


