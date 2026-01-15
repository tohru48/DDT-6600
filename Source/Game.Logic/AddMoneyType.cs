// Decompiled with JetBrains decompiler
// Type: Game.Logic.AddMoneyType
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic
{
  public enum AddMoneyType
  {
    Auction = 1,
    Mail = 2,
    Shop = 3,
    Marry = 4,
    Consortia = 5,
    Item = 6,
    Charge = 7,
    Award = 8,
    Box = 9,
    Game = 10, // 0x0000000A
    Auction_Update = 101, // 0x00000065
    Mail_Money = 201, // 0x000000C9
    Mail_Pay = 202, // 0x000000CA
    Mail_Send = 203, // 0x000000CB
    Shop_Buy = 301, // 0x0000012D
    Shop_Continue = 302, // 0x0000012E
    Shop_Card = 303, // 0x0000012F
    Shop_Present = 304, // 0x00000130
    Marry_Spark = 401, // 0x00000191
    Marry_Stage = 402, // 0x00000192
    Marry_Gift = 403, // 0x00000193
    Marry_Follow = 404, // 0x00000194
    Marry_Unmarry = 405, // 0x00000195
    Marry_Room = 406, // 0x00000196
    Marry_RoomAdd = 407, // 0x00000197
    Marry_Flower = 408, // 0x00000198
    Marry_Hymeneal = 410, // 0x0000019A
    Consortia_Rich = 412, // 0x0000019C
    Item_Move = 601, // 0x00000259
    Item_Color = 602, // 0x0000025A
    Charge_RMB = 701, // 0x000002BD
    Award_Daily = 801, // 0x00000321
    Award_Quest = 802, // 0x00000322
    Award_Drop = 803, // 0x00000323
    Award_Answer = 804, // 0x00000324
    Award_BossDrop = 805, // 0x00000325
    Award_TakeCard = 806, // 0x00000326
    Box_Open = 901, // 0x00000385
    Game_Boos = 1001, // 0x000003E9
    Game_PaymentTakeCard = 1002, // 0x000003EA
    Game_TryAgain = 1003, // 0x000003EB
    Game_Other = 1004, // 0x000003EC
    Game_Shoot = 1005, // 0x000003ED
  }
}
