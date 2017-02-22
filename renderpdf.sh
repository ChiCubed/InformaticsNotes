if ! [ -x "$(command -v pandoc)" ]; then
  echo 'Error: pandoc not installed. Follow the instructions at http://pandoc.org/installing.html.' >&2
  exit 1
fi
echo 'pandoc installation found... executing command' >&2
(set -x; pandoc InformaticsNotes.md -s --latex-engine=xelatex \
       -N --top-level-division=chapter --toc -o InformaticsNotes.pdf)
