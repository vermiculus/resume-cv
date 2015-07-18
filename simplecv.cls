\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\RequirePackage{expl3,xparse}
\ProvidesExplClass
{simplecv}
{2013/12/23}
{0.1}
{A class for simply-defined resume/curricula vitae}

\DeclareOption*{\PassOptionToClass{\CurrentOption}{article}}
\ProcessOptions*
\LoadClass{article}

\clist_new:N \g_bettercv_loaded_libraries_clist

\keys_define:nn { resume / options } {
  textout             .tl_gset:N   = \g_resume_options_output_text_file_tl,
  textout-preamble    .tl_gset:N   = \g_resume_options_output_text_preamble_tl,
  mark                .bool_gset:N = \g_resume_options_do_mark_bool,
}

\NewDocumentCommand \BetterSetup { m } {
  \keys_set:nn { resume / options } { #1 }
}


\RequirePackage{hyperref}
\RequirePackage{verbatim}
\RequirePackage{marvosym}

\cs_new:Nn \resume_library_use:n {
  \file_if_exist:nTF {./simplecv.#1.sty} {
    \RequirePackage{simplecv.#1}
    \clist_gpush:Nn \g_bettercv_loaded_libraries_clist { #1 }
    \use:c { bettercv_load_package_ #1 :}
  } {
    \typeout{! ~ No ~ such ~ library ~ #1.}
  }
}

\NewDocumentCommand \UseBetterCVLibrary { m } {
  \clist_set:Nn \l_tmpa_clist { #1 }
  \clist_map_function:NN \l_tmpa_clist \resume_library_use:n
}

\UseBetterCVLibrary{helper,header,position,project,edu,textfile,censor}

\pagestyle{empty}
\setcounter{secnumdepth}{0}

% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "cv.tex"
% TeX-engine: xetex
% End:
