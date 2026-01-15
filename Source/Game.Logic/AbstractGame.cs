// Decompiled with JetBrains decompiler
// Type: Game.Logic.AbstractGame
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class AbstractGame
  {
    private int int_0;
    protected eRoomType m_roomType;
    protected eGameType m_gameType;
    protected eMapType m_mapType;
    protected int m_timeType;
    private int int_1;
    private GameEventHandle gameEventHandle_0;
    private GameEventHandle gameEventHandle_1;

    public event GameEventHandle GameStarted
    {
      add
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_0;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_0, comparand + value, comparand);
        }
        while (gameEventHandle != comparand);
      }
      remove
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_0;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_0, comparand - value, comparand);
        }
        while (gameEventHandle != comparand);
      }
    }

    public event GameEventHandle GameStopped
    {
      add
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_1;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_1, comparand + value, comparand);
        }
        while (gameEventHandle != comparand);
      }
      remove
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_1;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_1, comparand - value, comparand);
        }
        while (gameEventHandle != comparand);
      }
    }

    public int Id => this.int_0;

    public eRoomType RoomType => this.m_roomType;

    public eGameType GameType => this.m_gameType;

    public int TimeType => this.m_timeType;

    public AbstractGame(int id, eRoomType roomType, eGameType gameType, int timeType)
    {
      this.int_0 = id;
      this.m_roomType = roomType;
      this.m_gameType = gameType;
      this.m_timeType = timeType;
      switch (this.m_roomType)
      {
        case eRoomType.Match:
          this.m_mapType = eMapType.PairUp;
          break;
        case eRoomType.Freedom:
          this.m_mapType = eMapType.Normal;
          break;
        default:
          this.m_mapType = eMapType.Normal;
          break;
      }
    }

    public virtual void Start() => this.OnGameStarted();

    public virtual void Stop() => this.OnGameStopped();

    public virtual bool CanAddPlayer() => false;

    public virtual void Pause(int time)
    {
    }

    public virtual void Resume()
    {
    }

    public virtual void MissionStart(IGamePlayer host)
    {
    }

    public virtual void ProcessData(GSPacketIn pkg)
    {
    }

    public virtual Player AddPlayer(IGamePlayer player) => (Player) null;

    public virtual Player RemovePlayer(IGamePlayer player, bool IsKick) => (Player) null;

    public void Dispose()
    {
      if (Interlocked.Exchange(ref this.int_1, 1) != 0)
        return;
      this.Dispose(true);
    }

    protected virtual void Dispose(bool disposing)
    {
    }

    protected void OnGameStarted()
    {
      if (this.gameEventHandle_0 == null)
        return;
      this.gameEventHandle_0(this);
    }

    protected void OnGameStopped()
    {
      if (this.gameEventHandle_1 == null)
        return;
      this.gameEventHandle_1(this);
    }
  }
}
