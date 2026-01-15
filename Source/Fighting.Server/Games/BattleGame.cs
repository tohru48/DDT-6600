// Decompiled with JetBrains decompiler
// Type: Fighting.Server.Games.BattleGame
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Fighting.Server.Rooms;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Maps;
using System.Collections.Generic;
using System.Text;

#nullable disable
namespace Fighting.Server.Games
{
  public class BattleGame : PVPGame
  {
    private ProxyRoom proxyRoom_0;
    private ProxyRoom proxyRoom_1;

    public ProxyRoom Red => this.proxyRoom_0;

    public ProxyRoom Blue => this.proxyRoom_1;

    public BattleGame(
      int id,
      List<IGamePlayer> red,
      ProxyRoom roomRed,
      List<IGamePlayer> blue,
      ProxyRoom roomBlue,
      Map map,
      eRoomType roomType,
      eGameType gameType,
      int timeType)
      : base(id, roomBlue.RoomId, red, blue, map, roomType, gameType, timeType)
    {
      this.proxyRoom_0 = roomRed;
      this.proxyRoom_1 = roomBlue;
    }

    public override void SendToAll(GSPacketIn pkg, IGamePlayer except)
    {
      if (this.proxyRoom_0 != null)
        this.proxyRoom_0.SendToAll(pkg, except);
      if (this.proxyRoom_1 == null)
        return;
      this.proxyRoom_1.SendToAll(pkg, except);
    }

    public override void SendToTeam(GSPacketIn pkg, int team, IGamePlayer except)
    {
      if (team == 1)
        this.proxyRoom_0.SendToAll(pkg, except);
      else
        this.proxyRoom_1.SendToAll(pkg, except);
    }

    public override string ToString()
    {
      return new StringBuilder(base.ToString()).Append(",class=BattleGame").ToString();
    }
  }
}
