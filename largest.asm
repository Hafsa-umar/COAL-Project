#include <iostream>
using namespace std;

template <class T>
class ParkingGrid
{
private:
    T** grid;
    int* slotCount;
    int levels;
    bool initialized;

public:

    ParkingGrid()
    {
        grid = NULL;
        slotCount = NULL;
        levels = 0;
        initialized = false;
    }

    void initialize()
    {
        cout << "Enter number of levels: ";
        cin >> levels;

        slotCount = new int[levels];
        grid = new T*[levels];

        cout << "Enter number of slots for each level:\n";

        for (int i = 0; i < levels; i++)
        {
            cout << "Level " << i + 1 << " slots: ";
            cin >> slotCount[i];

            grid[i] = new T[slotCount[i]];
        }

        initialized = true;
    }

    void inputOccupancy()
    {
        if (!initialized)
        {
            cout << "Parking grid is not initialized.\n";
            return;
        }

        for (int i = 0; i < levels; i++)
        {
            cout << "\nLevel " << i + 1 << ":\n";

            for (int j = 0; j < slotCount[i]; j++)
            {
                cout << "Slot " << j + 1 << " occupied for hours: ";
                cin >> grid[i][j];
            }
        }
    }

    void display()
    {
        if (!initialized)
        {
            cout << "Parking grid is not initialized.\n";
            return;
        }

        cout << "\n===== Parking Grid =====\n";

        for (int i = 0; i < levels; i++)
        {
            cout << "Level " << i + 1 << ": ";

            for (int j = 0; j < slotCount[i]; j++)
            {
                cout << grid[i][j] << " ";
            }

            cout << endl;
        }
    }

    T totalOccupiedHours()
    {
        T total = 0;

        for (int i = 0; i < levels; i++)
        {
            for (int j = 0; j < slotCount[i]; j++)
            {
                total = total + grid[i][j];
            }
        }

        return total;
    }

    void averagePerLevel()
    {
        if (!initialized)
        {
            cout << "Parking grid is not initialized.\n";
            return;
        }

        for (int i = 0; i < levels; i++)
        {
            T total = 0;

            for (int j = 0; j < slotCount[i]; j++)
            {
                total = total + grid[i][j];
            }

            double average = (double)total / slotCount[i];

            cout << "Average for Level "
                 << i + 1 << ": "
                 << average << endl;
        }
    }

    ~ParkingGrid()
    {
        if (grid != NULL)
        {
            for (int i = 0; i < levels; i++)
            {
                delete[] grid[i];
            }

            delete[] grid;
        }

        delete[] slotCount;
    }
};


int main()
{
    ParkingGrid<int> parking;

    parking.initialize();

    int choice;

    do
    {
        cout << "\n=== Smart Parking Management ===\n";
        cout << "1. Input Slot Occupancy\n";
        cout << "2. Display Parking Grid\n";
        cout << "3. Calculate Total Occupied Hours\n";
        cout << "4. Average Occupied Hours Per Level\n";
        cout << "0. Exit\n";

        cout << "Enter choice: ";
        cin >> choice;

        switch (choice)
        {
        case 1:
            parking.inputOccupancy();
            break;

        case 2:
            parking.display();
            break;

        case 3:
            cout << "Total Occupied Hours: "
                 << parking.totalOccupiedHours()
                 << endl;
            break;

        case 4:
            parking.averagePerLevel();
            break;

        case 0:
            cout << "Exiting...\n";
            break;

        default:
            cout << "Invalid choice!\n";
        }

    } while (choice != 0);

    return 0;
}