/*
    Author: _SCAR

    Description:
    Initializes a worker's animations.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: UNIT - The worker.

    Return:
    0: true

    Example:
    [_logicModule, _worker] call SCAR_UCM_fnc_loopWorkerMovements;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_worker"];

private _null = [_logicModule, _worker] spawn {

    params ["_logicModule", "_worker"];

    // vars
    private _workingDistance              = _logicModule getVariable "SCAR_UCM_workingDistance";
    private _workerAnimations             = _logicModule getVariable "SCAR_UCM_workerAnimations";

    // init
    private _lastPiece = objNull;

    // add kill event
    _worker addEventHandler ["Killed", {
        private _killed = _this select 0;
        private _logicModule  = _killed getVariable "_logicModule";
        // stop animation & sound
        [_logicModule, _killed, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];
    }];

    // set movements
    while { alive _worker } do {

        // get current piece
        private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

        // has work ended?
        if (_currentPiece isEqualTo objNull) exitWith {
            // stop animation & sound
            [_logicModule, _worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];
        };

        // set marker worker
        [_worker] call SCAR_UCM_fnc_setMarkerWorker;

        // check presence of worker (on the ground, not flying nearby, not in vehicle)
        if (
            ((_worker distance _currentPiece) < _workingDistance) &&
            (vehicle _worker == _worker)  &&
            (_logicModule getVariable "SCAR_UCM_workersAreWorking")
        ) then {
            // worker is in the area & work is happening

            if !(_currentPiece isEqualTo _lastPiece) then {

                // stop animation & sound
                [_logicModule, _worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];

                // get current piece size
                private _box = boundingBoxReal _currentPiece;
                private _p1 = _box select 0;
                private _p2 = _box select 1;
                private _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
                private _maxLength = abs ((_p2 select 1) - (_p1 select 1));

                // random position
                private _workersMinDistanceFromCenter = 1;
                private _sideX = selectRandom [1, -1];
                private _sideY = selectRandom [1, -1];

                private _relX = _sideX * (abs(random ((_maxWidth / 2) - _workersMinDistanceFromCenter)) + _workersMinDistanceFromCenter);
                private _relY = _sideY * (abs(random ((_maxLength / 2) - _workersMinDistanceFromCenter)) + _workersMinDistanceFromCenter);
                private _relativePos = [_relX, _relY, 0];

                // move worker close to piece

                // delete all existing waypoints
                private _group = group _worker;
                while {(count (waypoints _group)) > 0} do
                {
                    deleteWaypoint ((waypoints _group) select 0);
                };

                // set vars
                private _animation       = selectRandom _workerAnimations;
                private _pieceToWorldPos = _currentPiece modelToWorld _relativePos;
                private _rotation        = ((getDir _currentPiece) - _sideX * 90);
                _logicModule setVariable ["_logicModule", _logicModule, true];
                _worker setVariable ["_animation", _animation, true];
                _worker setVariable ["_pieceToWorldPos", _pieceToWorldPos, true];
                _worker setVariable ["_rotation", _rotation, true];

                // add waypoint
                private _wp = _group addWaypoint [_pieceToWorldPos, 0];
                _wp setWaypointType "MOVE";
                _wp setWaypointStatements ["true",
                    "private _logicModule = this getVariable '_logicModule';" +
                    "private _animation = this getVariable '_animation';" +
                    "private _pieceToWorldPos = this getVariable '_pieceToWorldPos';" +
                    "private _rotation = this getVariable '_rotation';" +
                    "[_logicModule, this, 1, _animation, _pieceToWorldPos, _rotation] remoteExec ['SCAR_UCM_fnc_setWorkerAnimation'];"
                ];

                // flag
                _lastPiece = _currentPiece;
            };
        } else {
            // not working

            // stop animation & sound
            [_logicModule, _worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];

            // reset
            _lastPiece = objNull;
        };

        sleep 10;
    };
};

// return
true
