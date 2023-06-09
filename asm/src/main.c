#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef enum { false, true } bool;

int max = 6;
int cursor = 0;

bool isAdmin;

char date[10+1] = "15/06/2014\0";   // 1 - Data: 15/06/2014
char time[5+1] = "15:32\0";         // 2 - Ora: 15:32
bool door_lock;                 // 3 - Blocco automatico porte: ON
bool back_home;                 // 4 - Back-home: ON
bool oil_check;                 // 5 - Check olio
int arrow = 3;                      // 6 * Frecce direzione
                                // 7 * Reset pressione gomme

bool IsAdmin(int argc, char *argv[])
{
    isAdmin = false;

    // supervisor ?
    for (unsigned int i = 0; i < argc; i++)
        if (strcmp(argv[i], "2244") == 0)
            return true;
    return false;
}

char GetArrowKey()
{
    char a, b, c, trash;
    scanf(" %c%c%c", &a, &b, &c);
    scanf("%c", &trash);
    return c;
}

void HandleSubmenuUP()
{
    switch (cursor)
    {
    // case 1: break;
    // case 2: break;
    case 3:
        door_lock = !door_lock;
        break;
    case 4:
        back_home = !back_home;
        break;
    case 6:
        arrow += arrow >= 5 ? 0 : 1;
        break;
    default:
        break;
    }
}

void HandleSubmenuDOWN()
{
    switch (cursor)
    {
    case 3:
        door_lock = !door_lock;
        break;
    case 4:
        back_home = !back_home;
        break;
    case 6:
        arrow -= arrow == 2 ? 0 : 1;
        break;
    default:
        break;
    }
}

void PrintMenu()
{
    switch (cursor)
    {
        case 0:
            {
                if (isAdmin)
                    printf("Setting automobile (supervisor)\n");
                else
                    printf("Setting automobile\n");
            };
            break;
        case 1:
            printf("Data: %s", date);
            break;
        case 2:
            printf("Ora: %s", time);
            break;
        case 3:
            printf("Blocco automatico porte: %s", door_lock ? "ON" : "OFF");
            break;
        case 4:
            printf("Back-home: %s", back_home ? "ON" : "OFF");
            break;
        case 5:
            printf("Check olio");
            break;
        case 6:
            printf("Frecce direzione: %d", arrow);
            break;
        case 7:
            printf("Reset pressione gomme");
            break;
    }
}

void Prev()
{
    if (cursor == 0)
        cursor = max - 1;
    else
        cursor--;
}
void Next()
{
    if (cursor == max)
        cursor = 0;
    else
        cursor++;
}

void OpenSubMenu()
{
    while (true)
    {

        // print current value or do nothing
        switch (cursor)
        {
        case 0:
            return;
        case 1:
            printf("%s", date);
            break;
        case 2:
            printf("%s", time);
            break;
        case 3:
            printf("%s", door_lock == true ? "ON" : "OFF");
            break;
        case 4:
            printf("%s", back_home == true ? "ON" : "OFF");
            break;
        case 5:
            printf("ok");
            return;
        case 6:
            printf("%d", arrow);
            break;
        case 7:
            printf("pressione gomme resettata");
            return;

        default:
            return;
        }

        // except a value
        char action;
        action = GetArrowKey();
        if (action == 'A' || action == 'a')
        {
            HandleSubmenuUP();
        };
        // Check for arrow character (down)
        if (action == 'B' || action == 'b')
        {
            HandleSubmenuDOWN();
        };
        // Check for arrow character (left)
        if (action == 'D' || action == 'd')
        {
            return;
        };
    };
}

void main(int argc, char *argv[])
{
    char action;

    // max = IsAdmin(argc, argv) ? 7 : 5; // TODO
    max = 7;

    while (true)
    {
        PrintMenu();

        action = GetArrowKey();
        // Check for arrow character (up)
        if (action == 'A' || action == 'a')
        {
            Prev();
            continue;
        };
        // Check for arrow character (down)
        if (action == 'B' || action == 'b')
        {
            Next();
            continue;
        };
        // Check for arrow character (right)
        if (action == 'C' || action == 'c')
        {
            OpenSubMenu();
            continue;
        };
        // Check for arrow character (left)
        if (action == 'D' || action == 'd')
        {
            continue;
        };
    }
}
