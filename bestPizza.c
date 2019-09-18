#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

#define PI 3.14159265358979323846


typedef struct pizza
{
	char name[64]; 
	int diameter; 
	float price; 
	float avgPrice; 
	struct pizza *next; 
} myPizzas;

int comparePizza(myPizzas *pizzaOne, myPizzas *pizzaTwo);
myPizzas* sortPizza(myPizzas *pizzaList, myPizzas *individual);

//myPizzas* findMax(myPizzas pizzas); 

int main(int argc, char* argv[])
{
	myPizzas *pizzas = NULL; 
	myPizzas *tmp = NULL; 

	FILE* input; 
	char* fileName = argv[1]; 
	input = fopen(fileName, "r"); 
	char line[64]; 

	int count = 1; 
	char name[64]; 
	int diameter; 
	float price; 
	while(1)
	{
	/*if (feof(input)){
		printf("PIZZA FILE IS EMPTY");
		fclose(input); 
		exit(0); 
	}*/
	if (fscanf(input, "%s\n", line) == EOF){
		printf("PIZZA FILE IS EMPTY");
		fclose(input); 
		exit(0); 
	}
	if (strcmp(line, "DONE") == 0){
		break; 
	}
	else if (count==1){
		strcpy(name, line);
		count = count+1; 
	}
	else if (count==2){
		diameter = atoi(line); 
		count = count+1; 

	}
	else if (count==3){
		price = atof(line); 
		myPizzas *pizza = (myPizzas*) malloc(sizeof(myPizzas)); 
		strcpy(pizza->name,name);
		pizza->diameter = diameter; 
		pizza->price = price; 
		pizza->next = NULL; 
		if (price == 0){
			pizza->avgPrice = 0; 
		}
		else{
		pizza->avgPrice = (float)pow(diameter,2)*PI/4/price; 
	}
		if (pizzas == NULL){
			pizzas = pizza; 
			tmp = pizza; 
		}
		else{
			pizzas = sortPizza(pizzas, pizza); 
		}
		count = 1; 
	}
}
	myPizzas *dup = pizzas; 
	while (dup != NULL){
		printf("%s %f\n", dup->name, dup->avgPrice);
		dup = dup->next; 
	}
	fclose(input); 
	while (pizzas != NULL){
		myPizzas *tmp = pizzas; 
		pizzas = pizzas->next; 
		free(tmp); 
	}
	return 0;
}

myPizzas* sortPizza(myPizzas *pizzaList, myPizzas *individual){
	myPizzas *tmp = pizzaList; 
	myPizzas *oldPizza = pizzaList;
	while(1){
		int compare = comparePizza(tmp, individual);
		if (compare > 0){
			oldPizza = tmp; 
			tmp = tmp->next; 
		}
		else if (compare <= 0 && oldPizza == tmp){
			individual->next = pizzaList; 
			pizzaList = individual; 
			return pizzaList; 
		}
		else if (compare <= 0){
			oldPizza->next = individual; 
			individual->next = tmp; 
			return pizzaList; 
		}

	}
	return pizzaList; 
}

int comparePizza(myPizzas *pizzaOne, myPizzas *pizzaTwo){
	if (pizzaOne == NULL){
		return -1; 
	}
	if (pizzaTwo == NULL){
		return 1; 
	}
	float oneP = pizzaOne->price; 
	float twoP = pizzaTwo->price; 
	float oneAvg = pizzaOne->avgPrice; 
	float twoAvg = pizzaTwo->avgPrice; 
	if (pizzaOne == NULL){
		return -1; 
	}
	if (pizzaTwo == NULL){
		return 1; 
	}
	else{
		if (oneAvg != twoAvg){
			return oneAvg - twoAvg; 
		}
		else{
			return strcmp(pizzaTwo->name, pizzaOne->name); 
		} 
	}
	return 0; 
}