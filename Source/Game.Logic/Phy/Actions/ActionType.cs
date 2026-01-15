// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Actions.ActionType
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic.Phy.Actions
{
  public enum ActionType
  {
    NULLSHOOT = -1, // 0xFFFFFFFF
    PICK = 1,
    BOMB = 2,
    START_MOVE = 3,
    FLY_OUT = 4,
    KILL_PLAYER = 5,
    TRANSLATE = 6,
    FORZEN = 7,
    CHANGE_SPEED = 8,
    UNFORZEN = 9,
    DANDER = 10, // 0x0000000A
    CURE = 11, // 0x0000000B
    GEM_DEFENSE_CHANGED = 12, // 0x0000000C
    CHANGE_STATE = 13, // 0x0000000D
    DO_ACTION = 14, // 0x0000000E
    PLAYBUFFER = 15, // 0x0000000F
    Laser = 16, // 0x00000010
    BOMBED = 17, // 0x00000011
    PUP = 18, // 0x00000012
    AUP = 19, // 0x00000013
    PET = 20, // 0x00000014
    WORLDCUP = 33, // 0x00000021
    PASS_BALL = 34, // 0x00000022
  }
}
