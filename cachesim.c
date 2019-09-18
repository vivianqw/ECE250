#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

int log2(int n);

int main(int argc, char *argv[]) {

  FILE* input;
  char* fileName = argv[1];
  int cacheSize = atoi(argv[2]);
  int assoc = atoi(argv[3]);
  int blockSize = atoi(argv[4]);
  input = fopen(fileName, "r");

  int numSets = (cacheSize<<10) / blockSize / assoc;
  int blockOff = log2(blockSize);
  int setOff = log2(numSets);
  //printf("Cache size %d kB, assoc %d, blockSize %d, numSets %d\n", cacheSize, assoc, blockSize, numSets);

  unsigned char* memory = (unsigned char*)malloc(2<<24);

  char saveLoad[64];
  int address = 0;
  int length = 0;
  char wordStored[64];

  int cache[numSets][assoc];

  for (int i = 0; i < numSets; i++) {
    for (int j = 0; j < assoc; j++) {
    	cache[i][j] = -1;
    }
  }

  while(1) {
    int valid = fscanf(input, "%s\t%x\t%d", saveLoad, &address, &length);
    if (valid == EOF){
      break;
    }

		int blockOffVal = address & ((1 << blockOff) - 1);
		int setOffVal = (address >> blockOff) & ((1 << setOff) - 1);
		int tagVal = (address >> blockOff) >> setOff;
    //  printf("blockoff %d, setoff %d, tagval %d\n", blockOffVal, setOffVal, tagVal);

    int hit = 0;

		if (saveLoad[0] == 's') {
      for (int i=0; i<length; i++){
        fscanf(input, "%02hhx", &memory[address + i]);
      }

      for (int i=0; i<assoc; i++){
        if (tagVal == cache[setOffVal][i]){
          //printf("tagval is %d\n", tagVal);
          hit = 1;
          for (int j=i; j>0; j--){
            cache[setOffVal][j] = cache[setOffVal][j-1];
            //printf("cache %d\n", cache[setOffVal][j])
          }
          cache[setOffVal][0] = tagVal;
          break;
        }
      }
      if (hit == 1){
		   		printf("%s 0x%x hit\n", saveLoad, address);
        }
		    else if (hit == 0){
		    	printf("%s 0x%x miss\n", saveLoad, address);
        }
      }

      if (saveLoad[0] == 'l') {
        for (int i=0; i<assoc; i++){
          if (tagVal == cache[setOffVal][i]){
            //printf("tagval is %d\n", tagVal);
            hit = 1;
            for (int j=i; j>0; j--){
              cache[setOffVal][j] = cache[setOffVal][j-1];
              //printf("cache %d\n", cache[setOffVal][j])
            }
            cache[setOffVal][0] = tagVal;
            break;
          }
        }

        if (hit == 1){
          printf("%s 0x%x hit ", saveLoad, address);
          for (int i=0; i<length; i++){
            printf("%02hhx", memory[address+i]);
          }
          printf("\n");
        }
        else if (hit == 0) {
          printf("%s 0x%x miss ", saveLoad, address);
          for (int i=0; i<length; i++){
            printf("%02hhx", memory[address + i]);
          }
          printf("\n");
          for (int i = assoc - 1; i>0; i--){
            cache[setOffVal][i] = cache[setOffVal][i-1];
          }
          cache[setOffVal][0] = tagVal;
        }
      }
    }
    return 0;
}

int log2(int n) {
  int r=0;
  while (n>>=1)
    r++;
  return r;
}
