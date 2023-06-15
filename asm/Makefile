# VARIABILI
	AS = as --32
	LD = ld -m elf_i386
	FLAGS = -gstabs
# ETICHETTE
build:
	$(AS) $(FLAGS) -o  ./obj/main.o ./src/main.s
	$(LD) -o bin/main ./obj/main.o
	@./bin/main
clean:
	@rm -f ./**/*.o
	@find . -type f -executable