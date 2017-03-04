if ! [ -x "$(command -v pandoc)" ]; then
  echo 'Error: pandoc not installed. Follow the instructions at http://pandoc.org/installing.html.' >&2
  exit 1
fi
if ! [ -x "$(command -v xelatex)" ]; then
  echo 'Error: XeLaTeX not found.' >&2
  echo 'Ensure you have installed the relevant LaTeX distribution using the instructions at http://pandoc.org/installing.html.' >&2
  exit 1
fi

<<<<<<< HEAD
dependencies=( sectsty tocloft )
=======
dependencies=( sectsty )
>>>>>>> 088764abf57afe3a27da02f09ebf5ca96d8b4e4c

for i in "${dependencies[@]}"
do
  if ! [ -e "$(kpsewhich $i.sty)" ]; then
    echo "Error: $i.sty package dependency not installed." >&2
    echo "Please run the command sudo tlmgr install $i to install it." >&2
    exit 1
  fi
  echo "found $i.sty"
done

echo 'pandoc installation found... executing render command'
(set -x; pandoc InformaticsNotes.md -s -f markdown -t latex --latex-engine=xelatex \
       -N --top-level-division=chapter --toc -o InformaticsNotes.pdf)
