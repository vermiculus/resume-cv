\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\RequirePackage{expl3,xparse}
\ProvidesExplClass
{bettercv}
{2013/12/23}
{1.0}
{A class for my resume/CV}
\DeclareOption*{\PassOptionToClass{\CurrentOption}{article}}
\ProcessOptions*
\LoadClass{article}

\keys_define:nn { resume / options } {
  textout             .tl_gset:N   = \g_resume_options_output_text_file_tl,
  textout~preamble    .tl_gset:N   = \g_resume_options_output_text_preamble_tl,
  mark                .bool_gset:N = \g_resume_options_do_mark_bool,
}

\NewDocumentCommand \BetterSetup { m } {
  \keys_set:nn { resume / options } { #1 }

  \tl_if_empty:NF \g_resume_options_output_text_file_tl {
    \iow_new:N \g_resume_output_text_iow
    \iow_open:Nn \g_resume_output_text_iow { \g_resume_options_output_text_file_tl }

    \ior_new:N \g_resume_output_text_preamble_ior
    \ior_open:Nn \g_resume_output_text_preamble_ior { \g_resume_options_output_text_preamble_tl }

    \ior_str_map_inline:Nn \g_resume_output_text_preamble_ior
      { \iow_now:Nn \g_resume_output_text_iow { #1 }
    }
  }
}


\RequirePackage{hyperref}
\RequirePackage{verbatim}
\RequirePackage{marvosym}

\input{bettercv.helper}

\input{bettercv.header}

\input{bettercv.position}

\input{bettercv.project}

\pagestyle{empty}
\setcounter{secnumdepth}{0}
% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "cv.tex"
% TeX-engine: xetex
% End:
