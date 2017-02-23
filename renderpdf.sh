if ! [ -x "$(command -v pandoc)" ]; then
  echo 'Error: pandoc not installed. Follow the instructions at http://pandoc.org/installing.html.' >&2
  exit 1
fi
if ! [ -x "$(command -v xelatex)" ]; then
  echo 'Error: XeLaTeX not found.' >&2
  echo 'Ensure you have installed the relevant LaTeX distribution using the instructions at http://pandoc.org/installing.html.' >&2
  exit 1
fi
if ! [ -x "$(kpsewhich sectsty)"]; then
  echo 'Error: sectsty.sty package not installed.' >&2
  echo 'Please run the command sudo tlmgr install sectsty to install it.' >&2
  exit 1
fi

echo 'pandoc installation found... executing render command'
(set -x; pandoc InformaticsNotes.md -s --latex-engine=xelatex \
       -N --top-level-division=chapter --toc -o InformaticsNotes.pdf)
