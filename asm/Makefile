# VARIABILI
	AS = as --32
	LD = ld -m elf_i386
	FLAGS = -gstabs
	CREATE_OBJ_FOLDER = @mkdir -p $(shell if [ ! -d "obj" ]; then echo "obj"; fi)
	CREATE_BIN_FOLDER = @mkdir -p $(shell if [ ! -d "bin" ]; then echo "bin"; fi)
# ETICHETTE
build:
	$(CREATE_BIN_FOLDER)
	$(CREATE_OBJ_FOLDER)
	$(AS) $(FLAGS) -o  ./obj/main.o ./src/main.s
	$(LD) -o bin/main ./obj/main.o
	@./bin/main
test:
	$(CREATE_BIN_FOLDER)
	$(CREATE_OBJ_FOLDER)
	$(AS) $(FLAGS) -o  ./obj/test.o ./src/test.s
	$(LD) -o bin/test ./obj/test.o
	@./bin/test
clean:
	@rm -f ./**/*.o
	@find . -type f -executable