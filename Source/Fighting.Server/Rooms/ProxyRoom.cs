// Decompiled with JetBrains decompiler
// Type: Fighting.Server.Rooms.ProxyRoom
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Game.Base.Packets;
using Game.Logic;
using log4net;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

#nullable disable
namespace Fighting.Server.Rooms
{
  public class ProxyRoom
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private List<IGamePlayer> list_0;
    private int int_0;
    private int int_1;
    private ServerClient gSuVtbUoTp;
    public int PickUpCount;
    public bool bool_0;
    public int selfId;
    public bool startWithNpc;
    public bool IsFreedom;
    private int int_2;
    private bool bool_1;
    public bool IsPlaying;
    public eGameType GameType;
    public eRoomType RoomType;
    public int GuildId;
    public string GuildName;
    public int AvgLevel;
    public int FightPower;
    private BaseGame baseGame_0;

    public int RoomId => this.int_0;

    public int OrientRoomId => this.int_1;

    public int NpcId
    {
      get => this.int_2;
      set => this.int_2 = value;
    }

    public bool isAutoBot => this.bool_1;

    public ServerClient Client => this.gSuVtbUoTp;

    public int PlayerCount => this.list_0.Count;

    public BaseGame Game => this.baseGame_0;

    public ProxyRoom(
      int roomId,
      int orientRoomId,
      IGamePlayer[] players,
      ServerClient client,
      int totallevel,
      int totalFightPower,
      int npcId,
      bool isAutoBot)
    {
      this.int_0 = roomId;
      this.int_2 = npcId;
      this.bool_1 = isAutoBot;
      this.int_1 = orientRoomId;
      this.list_0 = new List<IGamePlayer>();
      this.list_0.AddRange((IEnumerable<IGamePlayer>) players);
      this.gSuVtbUoTp = client;
      this.PickUpCount = 0;
      this.FightPower = totalFightPower;
      this.AvgLevel = totallevel / ((IEnumerable<IGamePlayer>) players).Count<IGamePlayer>();
      this.bool_0 = false;
    }

    public void SendToAll(GSPacketIn pkg) => this.SendToAll(pkg, (IGamePlayer) null);

    public void SendToAll(GSPacketIn pkg, IGamePlayer except)
    {
      this.gSuVtbUoTp.SendToRoom(this.int_1, pkg, except);
    }

    public List<IGamePlayer> GetPlayers()
    {
      List<IGamePlayer> players = new List<IGamePlayer>();
      lock (this.list_0)
        players.AddRange((IEnumerable<IGamePlayer>) this.list_0);
      return players;
    }

    public bool RemovePlayer(IGamePlayer player)
    {
      bool flag = false;
      lock (this.list_0)
      {
        if (this.list_0.Remove(player))
          flag = true;
      }
      if (this.PlayerCount == 0)
        ProxyRoomMgr.RemoveRoom(this);
      return flag;
    }

    public void StartGame(BaseGame game)
    {
      this.IsPlaying = true;
      this.baseGame_0 = game;
      game.GameStopped += new GameEventHandle(this.method_0);
      this.gSuVtbUoTp.SendStartGame(this.int_1, (AbstractGame) game);
    }

    private void method_0(AbstractGame abstractGame_0)
    {
      this.baseGame_0.GameStopped -= new GameEventHandle(this.method_0);
      this.IsPlaying = false;
      this.gSuVtbUoTp.SendStopGame(this.int_1, this.baseGame_0.Id);
    }

    public void Dispose() => this.gSuVtbUoTp.RemoveRoom(this.int_1, this);

    public override string ToString()
    {
      return string.Format("RoomId:{0} OriendId:{1} PlayerCount:{2},IsPlaying:{3},GuildId:{4},GuildName:{5}", (object) this.int_0, (object) this.int_1, (object) this.list_0.Count, (object) this.IsPlaying, (object) this.GuildId, (object) this.GuildName);
    }
  }
}
