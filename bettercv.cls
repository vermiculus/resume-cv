\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\RequirePackage{expl3,l3keys2e}
\ProvidesExplClass
{bettercv}
{2013/12/23}
{1.0}
{A class for my resume/CV}

\keys_define:nn { resume / options } {
  textout          .tl_set:N   = \g_resume_options_output_text_file_tl,
  textout preamble .tl_set:N   = \g_resume_options_output_text_preamble_tl,
  mark             .bool_set:N = \g_resume_options_do_mark_bool,
}

\ProcessKeysOptions{ resume / options }

\LoadClass{article}
\RequirePackage{fontspec}
\RequirePackage{hyperref}
\RequirePackage{marvosym}
\RequirePackage{titlesec}
\titleformat{\section}
{\Large\scshape}
{}
{}
{}
[\titlerule]
\titleformat*\subsection{\normalsize\bfseries}

\tl_if_empty:NF \g_resume_options_output_text_file_tl {
  \iow_new:N \g_resume_output_text_iow
  \iow_open:Nn \g_resume_output_text_iow { \g_resume_options_output_text_file_tl }

  \ior_new:N \g_resume_output_text_preamble_ior
  \ior_open:Nn \g_resume_output_text_preamble_ior { \g_resume_options_output_text_preamble_tl }

  \ior_str_map_inline:Nn \g_resume_output_text_preamble_ior
    { \iow_now:Nn \g_resume_output_text_iow { #1 }
  }
}

\cs_new:Nn \resume_maybe_write:n {
  \tl_if_empty:NF \g_resume_options_output_text_file_tl {
    \iow_shipout:Nx \g_resume_output_text_iow { #1 }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Logical Declarations and Markup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{xparse}

%% Date Range %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewDocumentCommand \daterange { s m m o }
{
  \IfBooleanTF{#1}
    {#2\thinspace\textendash\thinspace(#3)}
    {#2\thinspace\textendash\thinspace#3}
  \IfValueT { #4 } { \nobreakspace [#4] }
}

\NewDocumentCommand \Embrace { s O{-0.1ex} m } { % punpunpunpunpun
  \IfBooleanTF{#1}{\phantom{\raisebox{#2}{\texttt{\{}}}}
                  {         \raisebox{#2}{\texttt{\{}}}
  #3
  \IfBooleanTF{#1}{\phantom{\raisebox{#2}{\texttt{\}}}}}
                  {         \raisebox{#2}{\texttt{\}}}}
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
  url      .tl_set:N  = \l_resume_contact_url_tl,
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
      \l_resume_contact_phone_tl \\
      \ttfamily
      \l_resume_contact_email_tl \\
      \tl_if_empty:NF \l_resume_contact_url_tl { \l_resume_contact_url_tl \\ }
    \end{flushright}
  \end{minipage}
}

%% Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\keys_define:nn { resume / position }
{
  title       .tl_set:N   = \l_resume_position_title_tl,
  date        .tl_set:N   = \l_resume_position_date_tl,
  company     .tl_set:N   = \l_resume_position_company_tl,
  state       .tl_set:N   = \l_resume_position_state_tl,
  city        .tl_set:N   = \l_resume_position_city_tl,
  titlelink   .tl_set:N   = \l_resume_position_titlelink_tl,
  companylink .tl_set:N   = \l_resume_position_companylink_tl,
  technical   .bool_set:N = \l_resume_position_technical_bool,
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
    \tl_if_empty:NF \l_resume_position_titlelink_tl
                    { \href{\l_resume_position_titlelink_tl} }
    {\itshape \l_resume_position_title_tl}
    &
    \tl_if_empty:NF \l_resume_position_companylink_tl
                    { \href{\l_resume_position_companylink_tl} }
    {\l_resume_position_company_tl} \\[0.5ex]
    
    {\l_resume_position_date_tl}
    &
    {\l_resume_position_city_tl}, ~ {\l_resume_position_state_tl}
  \end{tabular*}

  \bool_if:NT \g_resume_options_do_mark_bool
  {
    \hspace{-\textwidth}
    \hspace{-4em}
    \raisebox{.25ex}{
      \bool_if:NTF \l_resume_position_technical_bool {\Embrace}{\Embrace*}
      \textreferencemark
    }
  }

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

\keys_define:nn { resume / project } {
  ghkey       .tl_set:N   = \l_resume_project_ghkey_tl,
  link        .tl_set:N   = \l_resume_project_link_tl,
  title       .tl_set:N   = \l_resume_project_title_tl,
  description .tl_set:N   = \l_resume_project_description_tl,
  date        .tl_set:N   = \l_resume_project_date_tl,
  technology  .tl_set:N   = \l_resume_project_technology_tl,
  technical   .bool_set:N = \l_resume_project_technical_bool,
}
\NewDocumentCommand \project { m } {
  \vspace{2ex plus .2ex minus .2ex}
  \par\noindent
  \group_begin:
  \keys_set:nn { resume / project } { #1 }
  \begin{tabular*}{\textwidth}{@{}l@{\extracolsep{\fill}}r@{}}
    \tl_if_empty:NF \l_resume_project_ghkey_tl
      { \href{\l_resume_project_link_tl} }
    { \parbox{3cm}{\l_resume_project_title_tl} }
    \tl_if_empty:NF \l_resume_project_ghkey_tl
      { \qquad \texttt{\l_resume_project_ghkey_tl} }
    &
    {\l_resume_project_technology_tl} \\[0.5ex]
    {\l_resume_project_description_tl}
    &
    {\l_resume_project_date_tl}
  \end{tabular*}

  \bool_if:NT \g_resume_options_do_mark_bool
  {
    \hspace{-\textwidth}
    \hspace{-4em}
    \raisebox{.25ex}{
      \bool_if:NTF \l_resume_project_technical_bool {\Embrace}{\Embrace*}
      \textreferencemark
    }
  }
  \group_end:
}

\AtBeginDocument{
  \maketitle
}
%\AtEndDocument{\vspace{0cm plus 1filll}}

\def\Dash{\unskip\thinspace\textemdash\thinspace\ignorespaces}

\pagestyle{empty}
\setcounter{secnumdepth}{0}
% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "cv.tex"
% TeX-engine: xetex
% End:
