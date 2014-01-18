\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\RequirePackage{expl3,l3keys2e}
\ProvidesExplClass
{bettercv}
{2013/12/23}
{1.0}
{A class for my resume/CV}

\keys_define:nn { resume / options } {
  textout .tl_set:N = \l_resume_output_text_tl,
  textout preamble .tl_set:N = \l_resume_output_text_preamble_tl
}

\ProcessKeysOptions{ resume / options }

\LoadClass{article}
\RequirePackage{fontspec}
\RequirePackage{hyperref}

\tl_if_empty:NF \l_resume_output_text_tl {
  \iow_new:N \g_resume_output_text_iow
  \iow_open:Nn \g_resume_output_text_iow { \l_resume_output_text_tl }

  \ior_new:N \g_resume_output_text_preamble_ior
  \ior_open:Nn \g_resume_output_text_preamble_ior { \l_resume_output_text_preamble_tl }

  \ior_str_map_inline:Nn \g_resume_output_text_preamble_ior
    { \iow_now:Nn \g_resume_output_text_iow { #1 }
  }
}

\cs_new:Nn \resume_maybe_write:n {
  \tl_if_empty:NF \l_resume_output_text_tl {
    \iow_shipout:Nx \g_resume_output_text_iow { #1 }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Logical Declarations and Markup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{xparse}

%% Date Range %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareDocumentCommand \daterange { s m m o }
{
  \IfBooleanTF{#1}
    {#2\thinspace\textendash\thinspace(#3)}
    {#2\thinspace\textendash\thinspace#3}
  \IfValueT { #4 } { \nobreakspace [#4] }
}

%% Address %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\keys_define:nn { resume/contact } {
  street   .tl_set:N  = \l_resume_contact_street_tl,
  city     .tl_set:N  = \l_resume_contact_city_tl,
  state    .tl_set:N  = \l_resume_contact_state_tl,
  zip      .tl_set:N  = \l_resume_contact_zip_tl,
  name     .tl_set:N  = \l_resume_contact_name_tl,
  phone    .tl_set:N  = \l_resume_contact_phone_tl,
  email    .tl_set:N  = \l_resume_contact_email_tl,
}

\NewDocumentCommand \ContactInformation { m }
{
  \keys_set:nn { resume / contact } { #1 }

  \resume_maybe_write:n
  {
    \exp_not:V \l_resume_contact_name_tl \iow_newline:
    \exp_not:V \l_resume_contact_email_tl \iow_newline:
    \exp_not:V \l_resume_contact_phone_tl \iow_newline:
    \iow_newline: 
    \exp_not:V \l_resume_contact_street_tl \iow_newline:
    \exp_not:V \l_resume_contact_city_tl ,\c_space_tl
    \exp_not:V \l_resume_contact_state_tl \iow_newline:
    \exp_not:V \l_resume_contact_zip_tl \iow_newline:
  }
}

% ensure that we don't have a HoeflerText situation again (as opposed
% to Hoefler Text)
\tl_new:N \l_resume_name_font_tl
\NewDocumentCommand \SetNameFont { m }
{
  \tl_set:Nn \l_resume_name_font_tl { #1 }
}

% yes, i do mean \maketitle.  Whoever heard of a two-column resume?
\RenewDocumentCommand \maketitle { }
{
  \noindent
  \begin{minipage}{.6\linewidth}
    \tl_if_empty:NF \l_resume_name_font_tl
                    { \fontspec[Path=fonts/]{\tl_use:N \l_resume_name_font_tl} }
    \Huge \hspace{-1em}
    \l_resume_contact_name_tl
  \end{minipage}
  \hfill
  \begin{minipage}{.4\linewidth}
    \begin{flushright}
      \l_resume_contact_street_tl\\

      \l_resume_contact_city_tl,~
      \l_resume_contact_state_tl
      \tl_if_empty:NF \l_resume_contact_zip_tl
        { ,~  \l_resume_contact_zip_tl }
        \\

      \l_resume_contact_phone_tl
    \end{flushright}
  \end{minipage}
}

%% Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\keys_define:nn { resume / position }
{
  title   .tl_set:N = \l_resume_position_title_tl,
  date    .tl_set:N = \l_resume_position_date_tl,
  company .tl_set:N = \l_resume_position_company_tl,
  state   .tl_set:N = \l_resume_position_state_tl,
  city    .tl_set:N = \l_resume_position_city_tl,
  titlelink .tl_set:N = \l_resume_position_titlelink_tl,
  companylink .tl_set:N = \l_resume_position_companylink_tl,
}

\NewDocumentEnvironment { position } { m }
{
  \par\noindent
%  \vfill
  \minipage{\textwidth}
  \par\vspace{2ex}\noindent

  \group_begin:
  \keys_set:nn { resume / position } { #1 }
  \begin{tabular*}{\textwidth}{@{}l@{\extracolsep{\fill}}r@{}}
    \tl_if_empty:NF \l_resume_position_titlelink_tl {\href{\l_resume_position_titlelink_tl}}
    {\itshape \l_resume_position_title_tl}
    &
    \tl_if_empty:NF \l_resume_position_companylink_tl {\href{\l_resume_position_companylink_tl}}
    {\l_resume_position_company_tl} \\[0.5ex]
    
    {\l_resume_position_date_tl}
    &
    {\l_resume_position_city_tl}, ~ {\l_resume_position_state_tl}
  \end{tabular*}

  \hspace{-\textwidth}
  \hspace{-4em}
  \raisebox{.25ex}{\textreferencemark}

  \resume_maybe_write:n {
    Position:\c_space_tl \exp_not:V \l_resume_position_title_tl   \iow_newline: 
    Company:\c_space_tl  \exp_not:V \l_resume_position_company_tl \iow_newline:
    Date:\c_space_tl     \exp_not:V \l_resume_position_date_tl    \iow_newline:
    Location:\c_space_tl \exp_not:V \l_resume_position_city_tl, \c_space_tl \l_resume_position_state_tl \iow_newline:
  }
  \group_end:
}
{
  \endminipage
  \vspace{4ex plus 1ex minus 1ex}
}

\AtBeginDocument{
  \maketitle
  % \vspace{2ex}\hspace*{.4\textwidth}\begin{minipage}{\textwidth}
  %   \usetikzlibrary{lindenmayersystems}
  %   \usetikzlibrary[shadings]
  %   \pgfdeclarelindenmayersystem{Fractal plant}{
  %   \rule{X -> F-[[X]+X]+F[+FX]-X}
  %   \rule{F -> FF}}
  %   \begin{tikzpicture}
  %     \draw [black!80!green, rotate=180, xscale=-1]
  %     [l-system={Fractal plant, axiom=X, order=6, step=2pt, angle=25}]
  %     lindenmayer system; 
  %   \end{tikzpicture}
  % \end{minipage}\vspace*{-48ex}
  % \vfill
}
\AtEndDocument{\vspace{0cm plus 1filll}}

\def\Dash{\unskip\thinspace\textemdash\thinspace\ignorespaces}

\pagestyle{empty}
\setcounter{secnumdepth}{0}
% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "cv.tex"
% TeX-engine: xetex
% End:
