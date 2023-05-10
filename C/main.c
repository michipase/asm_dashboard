#include<stdio.h>
#include<string.h>

/**
 * define an enum to be able to use true and false as 0 and 1 inside the code
*/
typedef enum {false, true} bool;
/**
 * Item is the struct containing the fields required for the dashboard
 * - text: a 32 string which contains the menu item text
 * - value: a 32 char string containing the field value 
 *  (note: this needs to be parsed differently for each menu item as they have different types)
 * - admin: a boolean flag that indicates if the field is accessible or not
*/
typedef struct Item
{       
    char text[32];
    char value[32];
    bool admin;
};

typedef struct Node
{       
    struct Item* data;
    struct Node* prev;
    struct Node* next;
};

struct Item arr[] = {
    {"Data", "15/06/2014", false},
    {"Ora", "15:32", false},
    {"Blocco automatico porte", "ON", false},
    {"Back-home", "ON", false},
    {"Check olio", "", false},
    {"Frecce direzione", "3", true},
    {"Reset pressione gomme", "", true}
};

struct Node* create_node(struct Item* data) {
    struct Node* new_node = malloc(sizeof(struct Node));

    new_node->data = data;
    new_node->prev = NULL;
    new_node->next = NULL;

    return new_node;
}

struct Node* create_list (struct Item* array, int size) {
    struct Node* head = create_node(&array[0]);
    struct Node* prev = head;

    for(int i = 1; i < size; i++) {
        struct Node* curr = create_node(&array[i]);
        prev->next = curr;
        curr->prev = prev;
        prev = curr; 
    }

    prev->next = head;
    head->prev = prev;
    return head;
}

struct Node* next_node(struct Node* current) {
    return current->next;
}
struct Node* next_node(struct Node* current) {
    return current->prev;
}

void change_value(struct Node* node, const char* new_value)
{
    strncpy(node->data->value, new_value, sizeof(node->data->value - 1));
    node->data->value[sizeof(node->data->value) - 1] = '\0';
}

struct Item* not_admin_filtered_items(struct Item* array, int size, int* filtered_size_ptr) {
    struct Item* filtered_array = malloc(size * sizeof(struct Item));
    int filtered_size = 0;

    for(int i = 0; i < size; i++) {
        if(array[i].admin == false) {
            filtered_array[filtered_size++] = array[i];
        }
    }
    *filtered_size_ptr = filtered_size;
    return filtered_array;
}

int main(int argc, char *argv[])
{
    int supervisor = false;
    struct Item* array = arr;

    // some setups ---------------
    int size = sizeof(array) / sizeof(array[0]);
    int filtered_size;


    for (unsigned int i = 0; i < argc; i++) {
        if (strcmp(argv[i], "2244") == 0) {
            supervisor = true;
            array = not_admin_filtered_items(array,size, &filtered_size);
        }
    }



    
    return 0;
}