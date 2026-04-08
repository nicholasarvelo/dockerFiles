### add shell functions here ###

radssh() {
  host_file=$1
  python -m radssh.shell "./hosts/$host_file"
}
