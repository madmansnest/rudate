install_dir := ~/bin

install:
	cp rudate.rb $(install_dir)/rudate
	cp zhdate.rb $(install_dir)/zhdate
	cp runum.rb $(install_dir)/runum
	cp rusum.rb $(install_dir)/rusum

uninstall:
	rm $(install_dir)/rudate $(install_dir)/zhdate $(install_dir)/runum $(install_dir)/rusum
