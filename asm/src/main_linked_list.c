#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// * TYPEDEF ======================================
/**
 * define an enum to be able to use true and false as 0 and 1 inside the code
 */
typedef enum { false, true } bool;
/**
 * Item is the struct containing the fields required for the dashboard
 * - instr: the function code to call when this field is selected
 * - text: a 32 string which contains the menu item text
 * - value: a 32 char string containing the field value
 *  (note: this needs to be parsed differently for each menu item as they have different types)
 * - admin: a boolean flag that indicates if the field is accessible or not
 */
typedef struct Item
{
    int instr;
    char text[32];
    char value[32];
    bool admin;
};

/**
 * Node is the structure containing the pointer to previous and next item in the circular list
 * it also contain a data field of type Item
 */
typedef struct Node
{
    struct Item *data;
    struct Node *prev;
    struct Node *next;
};

// * GLOBAL variables =====================

// arr is the default array of instructions
// TODO place it in a config file
struct Item arr[] = {
    {0, "Data", "15/06/2014", false},
    {1, "Ora", "15:32", false},
    {2, "Blocco automatico porte", "ON", false},
    {3, "Back-home", "ON", false},
    {4, "Check olio", "", false},
    {5, "Frecce direzione", "3", true},
    {6, "Reset pressione gomme", "", true}};

// * METHODS ===================================================0

/**
 * Create a void node with the given Item data
 * @param data - the Item instance to assign to the Node
 * @return a Node element
 */
struct Node *create_node(struct Item *data)
{
    struct Node *new_node = malloc(sizeof(struct Node));

    new_node->data = data;
    new_node->prev = NULL;
    new_node->next = NULL;

    return new_node;
}

/**
 * Create a circular linked list based on Item array
 * @param array The array of Item to convert in a circular linked list
 * @param size The size of array
 * @return The first node of the newly created circular linked list
 */
struct Node *create_list(struct Item *array, int size)
{
    struct Node *head = create_node(&array[0]);
    struct Node *prev = head;

    for (int i = 1; i < size; i++)
    {
        struct Node *curr = create_node(&array[i]);
        prev->next = curr;
        curr->prev = prev;
        prev = curr;
    }

    prev->next = head;
    head->prev = prev;
    return head;
}

/**
 * Get the next element in the circular linked list
 * @param current The current Node
 * @return The next node in the circular linked list
 */
struct Node *next_node(struct Node *current)
{
    return current->next;
}
/**
 * Get the previous element in the circular linked list
 * @param current The current Node
 * @return The previous node in the circular linked list
 */
struct Node *prev_node(struct Node *current)
{
    return current->prev;
}
/**
 * Sets a different Item value to the current Node->data->value
 * @param node The current Node
 * @param new_value the string value to assign to the node
 * @return Nothing
 */
void change_value(struct Node *node, const char *new_value)
{
    strncpy(node->data->value, new_value, sizeof(node->data->value - 1));
    node->data->value[sizeof(node->data->value) - 1] = '\0';
}
/**
 * This function filter an array of items by non-admin values
 * @param array The array of items that will be filtered
 * @param size The size of the initial array
 * @param filtered_size_ptr The pointer to store the filtered array size
 * @return The array filtered by admin == false
 */
struct Item *not_admin_filtered_items(struct Item *array, int size, int *filtered_size_ptr)
{
    struct Item *filtered_array = malloc(size * sizeof(struct Item));
    int filtered_size = 0;

    for (int i = 0; i < size; i++)
    {
        if (array[i].admin == false)
        {
            filtered_array[filtered_size++] = array[i];
        }
    }
    *filtered_size_ptr = filtered_size;
    return filtered_array;
}

int main(int argc, char *argv[])
{
    int supervisor = false;
    struct Item *array = arr;

    // setups
    int size = sizeof(array) / sizeof(array[0]);
    int filtered_size;

    for (unsigned int i = 0; i < argc; i++)
    {
        if (strcmp(argv[i], "2244") == 0)
        {
            supervisor = true;
            array = not_admin_filtered_items(array, size, &filtered_size);
            size = sizeof(array) / sizeof(array[0]);
        }
    }

    /** // TODO LIST
     *  - show menu title based on admin
     *  - get user input
     *  - on top go to prev
     *  - on botton go to next
     *  - on right call the function relative to current node
     *  - create function for each item of array
     *      > each must have the correct submenu of options to assign to the new value (call change_value)
     */ 
    

    return 0;
}