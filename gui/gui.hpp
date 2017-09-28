#include "base_classes.hpp"

class SCAR_UCM_SelectVehicleDialog {

    show = 0;
    movingEnable = 1;
    idd = -1;

    class ControlsBackground {

        class SCAR_UCM_SelectVehicle_Mainback: RscPicture
        {

            idc = -1;
            x = 0.396875 * safezoneW + safezoneX;
            y = 0.302 * safezoneH + safezoneY;
            w = 0.211406 * safezoneW;
            h = 0.33 * safezoneH;
            moving = 1;
            text = "#(argb,8,8,3)color(0,0,0,0.7)";
        };
    };

    class Controls {

        class SCAR_UCM_SelectVehicle_frame: RscFrame
        {
            idc = -1;
            x = 0.396875 * safezoneW + safezoneX;
            y = 0.302 * safezoneH + safezoneY;
            w = 0.211406 * safezoneW;
            h = 0.33 * safezoneH;
            moving = 1;
        };
        class SCAR_UCM_SelectVehicle_title: RscText
        {
            idc = -1;
            text = $STR_SCAR_UCM_Main_ChooseVehicle;
            x = 0.402031 * safezoneW + safezoneX;
            y = 0.313 * safezoneH + safezoneY;
            w = 0.195937 * safezoneW;
            h = 0.022 * safezoneH;
        };
        class SCAR_UCM_SelectVehicle_listbox: RscListbox
        {
            idc = 21950;
            x = 0.402031 * safezoneW + safezoneX;
            y = 0.346 * safezoneH + safezoneY;
            w = 0.201094 * safezoneW;
            h = 0.242 * safezoneH;
        };
        class SCAR_UCM_SelectVehicle_CANCEL: RscButtonMenuCancel
        {
            x = 0.402031 * safezoneW + safezoneX;
            y = 0.599 * safezoneH + safezoneY;
            w = 0.0464063 * safezoneW;
            h = 0.022 * safezoneH;
            action = "closeDialog 2;";
        };
        class SCAR_UCM_SelectVehicle_OK: RscButtonMenuOK
        {
            x = 0.556719 * safezoneW + safezoneX;
            y = 0.599 * safezoneH + safezoneY;
            w = 0.0464063 * safezoneW;
            h = 0.022 * safezoneH;
            action = "[] call SCAR_UCM_fnc_guiVehicleSelect;";
        };
    };
};