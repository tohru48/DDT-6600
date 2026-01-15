// Decompiled with JetBrains decompiler
// Type: Game.Logic.BaseGame
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class BaseGame : AbstractGame
  {
    public static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected int turnIndex;
    protected int m_nextPlayerId;
    protected int m_nextWind;
    protected eGameState m_gameState;
    protected Map m_map;
    protected Dictionary<int, Player> m_players;
    protected List<Living> m_livings;
    protected Random m_random;
    protected TurnedLiving m_currentLiving;
    public TurnedLiving LastTurnLiving;
    public int PhysicalId;
    public int CurrentTurnTotalDamage;
    public int TotalHurt;
    public int redScore;
    public int blueScore;
    public int ConsortiaAlly;
    public int RichesRate;
    public string BossWarField;
    private ArrayList arrayList_0;
    private List<TurnedLiving> list_0;
    private int int_2;
    public int[] Cards;
    private int int_3;
    private long long_0;
    private long long_1;
    public int CurrentActionCount;
    public int loadBossID;
    private List<Ball> list_1;
    private List<Box> list_2;
    private List<Point> list_3;
    private List<LoadingFileInfo> list_4;
    public int TotalCostMoney;
    public int TotalCostGold;
    private GameEventHandle gameEventHandle_2;
    private GameEventHandle gameEventHandle_3;
    private BaseGame.GameOverLogEventHandle iOqupaYcDc;
    private BaseGame.GameNpcDieEventHandle gameNpcDieEventHandle_0;

    public event GameEventHandle GameOverred
    {
      add
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_2;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_2, comparand + value, comparand);
        }
        while (gameEventHandle != comparand);
      }
      remove
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_2;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_2, comparand - value, comparand);
        }
        while (gameEventHandle != comparand);
      }
    }

    public event GameEventHandle BeginNewTurn
    {
      add
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_3;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_3, comparand + value, comparand);
        }
        while (gameEventHandle != comparand);
      }
      remove
      {
        GameEventHandle gameEventHandle = this.gameEventHandle_3;
        GameEventHandle comparand;
        do
        {
          comparand = gameEventHandle;
          gameEventHandle = Interlocked.CompareExchange<GameEventHandle>(ref this.gameEventHandle_3, comparand - value, comparand);
        }
        while (gameEventHandle != comparand);
      }
    }

    public event BaseGame.GameOverLogEventHandle GameOverLog
    {
      add
      {
        BaseGame.GameOverLogEventHandle overLogEventHandle = this.iOqupaYcDc;
        BaseGame.GameOverLogEventHandle comparand;
        do
        {
          comparand = overLogEventHandle;
          overLogEventHandle = Interlocked.CompareExchange<BaseGame.GameOverLogEventHandle>(ref this.iOqupaYcDc, comparand + value, comparand);
        }
        while (overLogEventHandle != comparand);
      }
      remove
      {
        BaseGame.GameOverLogEventHandle overLogEventHandle = this.iOqupaYcDc;
        BaseGame.GameOverLogEventHandle comparand;
        do
        {
          comparand = overLogEventHandle;
          overLogEventHandle = Interlocked.CompareExchange<BaseGame.GameOverLogEventHandle>(ref this.iOqupaYcDc, comparand - value, comparand);
        }
        while (overLogEventHandle != comparand);
      }
    }

    public event BaseGame.GameNpcDieEventHandle GameNpcDie
    {
      add
      {
        BaseGame.GameNpcDieEventHandle npcDieEventHandle = this.gameNpcDieEventHandle_0;
        BaseGame.GameNpcDieEventHandle comparand;
        do
        {
          comparand = npcDieEventHandle;
          npcDieEventHandle = Interlocked.CompareExchange<BaseGame.GameNpcDieEventHandle>(ref this.gameNpcDieEventHandle_0, comparand + value, comparand);
        }
        while (npcDieEventHandle != comparand);
      }
      remove
      {
        BaseGame.GameNpcDieEventHandle npcDieEventHandle = this.gameNpcDieEventHandle_0;
        BaseGame.GameNpcDieEventHandle comparand;
        do
        {
          comparand = npcDieEventHandle;
          npcDieEventHandle = Interlocked.CompareExchange<BaseGame.GameNpcDieEventHandle>(ref this.gameNpcDieEventHandle_0, comparand - value, comparand);
        }
        while (npcDieEventHandle != comparand);
      }
    }

    protected int m_turnIndex
    {
      get => this.turnIndex;
      set => this.turnIndex = value;
    }

    public int RoomId => this.int_2;

    public Dictionary<int, Player> Players => this.m_players;

    public int PlayerCount
    {
      get
      {
        int count;
        lock (this.m_players)
          count = this.m_players.Count;
        return count;
      }
    }

    public int TurnIndex
    {
      get => this.m_turnIndex;
      set => this.m_turnIndex = value;
    }

    public int nextPlayerId
    {
      get => this.m_nextPlayerId;
      set => this.m_nextPlayerId = value;
    }

    public eGameState GameState => this.m_gameState;

    public float Wind => this.m_map.wind;

    public Map Map => this.m_map;

    public List<TurnedLiving> TurnQueue => this.list_0;

    public bool HasPlayer => this.m_players.Count > 0;

    public Random Random => this.m_random;

    public TurnedLiving CurrentLiving => this.m_currentLiving;

    public int LifeTime => this.int_3;

    public BaseGame(
      int id,
      int roomId,
      Map map,
      eRoomType roomType,
      eGameType gameType,
      int timeType)
      : base(id, roomType, gameType, timeType)
    {
      this.list_4 = new List<LoadingFileInfo>();
      this.int_2 = roomId;
      this.m_players = new Dictionary<int, Player>();
      this.list_0 = new List<TurnedLiving>();
      this.m_livings = new List<Living>();
      this.m_random = new Random();
      this.m_map = map;
      this.arrayList_0 = new ArrayList();
      this.PhysicalId = 0;
      this.BossWarField = "";
      this.list_2 = new List<Box>();
      this.list_1 = new List<Ball>();
      this.list_3 = new List<Point>();
      this.Cards = this.RoomType == eRoomType.Dungeon || this.RoomType == eRoomType.SpecialActivityDungeon ? new int[21] : new int[9];
      this.m_gameState = eGameState.Inited;
    }

    public void SetWind(int wind) => this.m_map.wind = (float) wind;

    public bool SetMap(int mapId)
    {
      if (this.GameState == eGameState.Playing)
        return false;
      Map map = MapMgr.CloneMap(mapId);
      if (map == null)
        return false;
      this.m_map = map;
      return true;
    }

    public int GetTurnWaitTime() => this.m_timeType;

    protected void AddPlayer(IGamePlayer gp, Player fp)
    {
      lock (this.m_players)
      {
        this.m_players.Add(fp.Id, fp);
        if (fp.Weapon == null)
          return;
        this.list_0.Add((TurnedLiving) fp);
      }
    }

    public void SelectObject(int id, int zoneId)
    {
      lock (this.m_players)
        ;
    }

    public bool IsPVE()
    {
      eRoomType roomType = this.RoomType;
      if (roomType != eRoomType.Dungeon && roomType != eRoomType.Lanbyrinth)
      {
        switch (roomType)
        {
          case eRoomType.CampBattleBattle:
          case eRoomType.ActivityDungeon:
            break;
          default:
            return false;
        }
      }
      return true;
    }

    public virtual void AddLiving(Living living)
    {
      this.m_map.AddPhysical((Physics) living);
      switch (living)
      {
        case Player _ when (living as Player).Weapon == null:
          return;
        case TurnedLiving _:
          this.list_0.Add(living as TurnedLiving);
          break;
        default:
          this.m_livings.Add(living);
          break;
      }
      this.method_20(living);
    }

    public virtual void AddPhysicalObj(PhysicalObj phy, bool sendToClient)
    {
      this.m_map.AddPhysical((Physics) phy);
      phy.SetGame(this);
      if (!sendToClient)
        return;
      this.method_13(phy);
    }

    public virtual void AddPhysicalTip(PhysicalObj phy, bool sendToClient)
    {
      this.m_map.AddPhysical((Physics) phy);
      phy.SetGame(this);
      if (!sendToClient)
        return;
      this.method_14(phy);
    }

    public override Player RemovePlayer(IGamePlayer gp, bool IsKick)
    {
      Player player1 = (Player) null;
      lock (this.m_players)
      {
        foreach (Player player2 in this.m_players.Values)
        {
          if (player2.PlayerDetail == gp)
          {
            player1 = player2;
            this.m_players.Remove(player2.Id);
            break;
          }
        }
      }
      if (player1 != null)
        this.AddAction((IAction) new RemovePlayerAction(player1));
      return player1;
    }

    public void RemovePhysicalObj(PhysicalObj phy, bool sendToClient)
    {
      this.m_map.RemovePhysical((Physics) phy);
      phy.SetGame((BaseGame) null);
      if (!sendToClient)
        return;
      this.method_18(phy);
    }

    public void RemoveLiving(int id)
    {
      foreach (Living living in this.m_livings)
      {
        if (living.Id == id)
        {
          this.m_map.RemovePhysical((Physics) living);
          if (living is TurnedLiving)
            this.list_0.Remove(living as TurnedLiving);
          else
            this.m_livings.Remove(living);
        }
      }
      this.method_19(id);
    }

    public List<Living> GetLivedLivings()
    {
      List<Living> livedLivings = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living.IsLiving)
          livedLivings.Add(living);
      }
      return livedLivings;
    }

    public List<Living> GetLivedLivingsHadTurn()
    {
      List<Living> livedLivingsHadTurn = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living.IsLiving && living is SimpleNpc && living.Config.HasTurn)
          livedLivingsHadTurn.Add(living);
      }
      return livedLivingsHadTurn;
    }

    public List<Living> GetBossLivings()
    {
      List<Living> bossLivings = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living.IsLiving && living is SimpleBoss)
          bossLivings.Add(living);
      }
      return bossLivings;
    }

    public void ClearAllChild()
    {
      List<Living> livingList = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living.IsLiving && living is SimpleNpc)
          livingList.Add(living);
      }
      foreach (Living living in livingList)
      {
        this.m_livings.Remove(living);
        living.Dispose();
        this.RemoveLiving(living.Id);
      }
    }

    public void method_0(int Id)
    {
      List<Living> livingList = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living.Id == Id)
          livingList.Add(living);
      }
      foreach (Living living in livingList)
      {
        this.m_livings.Remove(living);
        living.Dispose();
        this.RemoveLiving(living.Id);
      }
    }

    public List<Living> GetFightFootballLivings()
    {
      List<Living> fightFootballLivings = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living is SimpleNpc)
          fightFootballLivings.Add(living);
      }
      return fightFootballLivings;
    }

    public void ClearAllNpc()
    {
      List<Living> livingList = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living is SimpleNpc)
          livingList.Add(living);
      }
      foreach (Living living in livingList)
      {
        this.m_livings.Remove(living);
        living.Dispose();
        this.method_19(living.Id);
      }
      foreach (Physics phy in this.m_map.GetAllPhysicalSafe())
      {
        if (phy is SimpleNpc)
          this.m_map.RemovePhysical(phy);
      }
    }

    public void ClearDiedPhysicals()
    {
      List<Living> livingList1 = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (!living.IsLiving)
          livingList1.Add(living);
      }
      foreach (Living living in livingList1)
      {
        this.m_livings.Remove(living);
        living.Dispose();
      }
      List<Living> livingList2 = new List<Living>();
      foreach (TurnedLiving turnedLiving in this.list_0)
      {
        if (!turnedLiving.IsLiving)
          livingList2.Add((Living) turnedLiving);
      }
      foreach (TurnedLiving turnedLiving in livingList2)
        this.list_0.Remove(turnedLiving);
      foreach (Physics phy in this.m_map.GetAllPhysicalSafe())
      {
        if (!phy.IsLiving && !(phy is Player))
          this.m_map.RemovePhysical(phy);
      }
    }

    public bool IsAllComplete()
    {
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (allFightPlayer.LoadingProcess < 100)
          return false;
      }
      return true;
    }

    public Player FindPlayer(int id)
    {
      lock (this.m_players)
      {
        if (this.m_players.ContainsKey(id))
          return this.m_players[id];
      }
      return (Player) null;
    }

    public TurnedLiving FindNextTurnedFightFootball()
    {
      if (this.list_0.Count == 0)
        return (TurnedLiving) null;
      TurnedLiving turnedFightFootball = this.list_0[this.m_random.Next(this.list_0.Count - 1)];
      if (this.TurnIndex > 0)
      {
        for (int index = 0; index < this.list_0.Count; ++index)
        {
          if ((this.list_0[index] as Player).PlayerDetail.PlayerCharacter.ID == this.m_nextPlayerId)
          {
            turnedFightFootball = this.list_0[index];
            break;
          }
        }
      }
      ++turnedFightFootball.TurnNum;
      for (int index = 0; index < this.list_0.Count; ++index)
      {
        if (this.list_0[index].Team != turnedFightFootball.Team && this.list_0[index].TurnNum < turnedFightFootball.TurnNum)
        {
          this.m_nextPlayerId = (this.list_0[index] as Player).PlayerDetail.PlayerCharacter.ID;
          return turnedFightFootball;
        }
        this.m_nextPlayerId = (this.list_0[this.m_random.Next(this.list_0.Count - 1)] as Player).PlayerDetail.PlayerCharacter.ID;
      }
      return turnedFightFootball;
    }

    public TurnedLiving FindNextTurnedLiving()
    {
      if (this.list_0.Count == 0)
        return (TurnedLiving) null;
      TurnedLiving nextTurnedLiving = this.list_0[this.m_random.Next(this.list_0.Count - 1)];
      int delay = nextTurnedLiving.Delay;
      for (int index = 0; index < this.list_0.Count; ++index)
      {
        if (this.list_0[index].Delay < delay && this.list_0[index].IsLiving)
        {
          delay = this.list_0[index].Delay;
          nextTurnedLiving = this.list_0[index];
        }
      }
      ++nextTurnedLiving.TurnNum;
      return nextTurnedLiving;
    }

    public TurnedLiving[] GetNextAllTurnedLiving()
    {
      if (this.list_0.Count == 0)
        return (TurnedLiving[]) null;
      List<TurnedLiving> turnedLivingList = new List<TurnedLiving>();
      for (int index = 0; index < this.list_0.Count; ++index)
      {
        if (this.list_0[index].IsLiving && !this.list_0[index].IsFrost && !this.list_0[index].IsAttacking && this.list_0[index] is Player)
        {
          ++this.list_0[index].TurnNum;
          turnedLivingList.Add(this.list_0[index]);
        }
      }
      return turnedLivingList.ToArray();
    }

    public virtual void MinusDelays(int lowestDelay)
    {
      foreach (TurnedLiving turnedLiving in this.list_0)
        turnedLiving.Delay -= lowestDelay;
    }

    public SimpleBoss[] FindAllBoss()
    {
      List<SimpleBoss> simpleBossList = new List<SimpleBoss>();
      foreach (Living living in this.m_livings)
      {
        if (living is SimpleBoss)
          simpleBossList.Add(living as SimpleBoss);
      }
      return simpleBossList.ToArray();
    }

    public bool ArenaPK()
    {
      eRoomType roomType = this.RoomType;
      if (roomType != eRoomType.ConsortiaBattle && roomType != eRoomType.RingStation)
      {
        switch (roomType)
        {
          case eRoomType.Entertainment:
          case eRoomType.EntertainmentPK:
            break;
          default:
            return false;
        }
      }
      return true;
    }

    public bool ArenaBoss()
    {
      switch (this.RoomType)
      {
        case eRoomType.FarmBoss:
        case eRoomType.Cryptboss:
          return true;
        default:
          return false;
      }
    }

    public SimpleNpc[] FindAllNpc()
    {
      List<SimpleNpc> simpleNpcList = new List<SimpleNpc>();
      foreach (Living living in this.m_livings)
      {
        if (living is SimpleNpc)
        {
          simpleNpcList.Add(living as SimpleNpc);
          return simpleNpcList.ToArray();
        }
      }
      return (SimpleNpc[]) null;
    }

    public float GetNextWind()
    {
      int num1 = (int) ((double) this.Wind * 10.0);
      int num2;
      if (num1 > this.m_nextWind)
      {
        num2 = num1 - this.m_random.Next(11);
        if (num1 <= this.m_nextWind)
          this.m_nextWind = this.m_random.Next(-40, 40);
      }
      else
      {
        num2 = num1 + this.m_random.Next(11);
        if (num1 >= this.m_nextWind)
          this.m_nextWind = this.m_random.Next(-40, 40);
      }
      return (float) num2 / 10f;
    }

    public void UpdateWind(float wind, bool sendToClient)
    {
      if ((double) this.m_map.wind == (double) wind)
        return;
      this.m_map.wind = wind;
      if (sendToClient)
        this.method_43(wind);
    }

    public void TakePassBall(int livvingId)
    {
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (allFightPlayer != null)
        {
          allFightPlayer.SyncAtTime = true;
          if (allFightPlayer.Id == livvingId)
            allFightPlayer.HoldingBall(true);
          else
            allFightPlayer.HoldingBall(false);
        }
      }
    }

    public int GetDiedPlayerCount()
    {
      int diedPlayerCount = 0;
      foreach (Player player in this.m_players.Values)
      {
        if (player.IsActive && !player.IsLiving)
          ++diedPlayerCount;
      }
      return diedPlayerCount;
    }

    public int GetDiedNPCCount()
    {
      int diedNpcCount = 0;
      foreach (Physics physics in this.FindAllNpc())
      {
        if (!physics.IsLiving)
          ++diedNpcCount;
      }
      return diedNpcCount;
    }

    public int GetDiedCount() => this.GetDiedNPCCount() + this.GetDiedBossCount();

    public int GetDiedBossCount()
    {
      int diedBossCount = 0;
      foreach (Physics physics in this.FindAllBoss())
      {
        if (!physics.IsLiving)
          ++diedBossCount;
      }
      return diedBossCount;
    }

    protected Point GetPlayerPoint(MapPoint mapPos, int team)
    {
      List<Point> pointList = team == 1 ? mapPos.PosX : mapPos.PosX1;
      int index = this.m_random.Next(pointList.Count);
      Point playerPoint = pointList[index];
      pointList.Remove(playerPoint);
      return playerPoint;
    }

    public virtual void CheckState(int delay)
    {
    }

    public override void ProcessData(GSPacketIn packet)
    {
      if (!this.m_players.ContainsKey(packet.Parameter1))
        return;
      this.AddAction((IAction) new ProcessPacketAction(this.m_players[packet.Parameter1], packet));
    }

    public Player GetPlayerByIndex(int index)
    {
      return this.m_players.ElementAt<KeyValuePair<int, Player>>(index).Value;
    }

    public Player FindNearestPlayer(int x, int y)
    {
      double num1 = double.MaxValue;
      Player nearestPlayer = (Player) null;
      foreach (Player player in this.m_players.Values)
      {
        if (player.IsLiving)
        {
          double num2 = player.Distance(x, y);
          if (num2 < num1)
          {
            num1 = num2;
            nearestPlayer = player;
          }
        }
      }
      return nearestPlayer;
    }

    public List<Living> FindHoldBall()
    {
      List<Living> holdBall = new List<Living>();
      foreach (Living living in this.m_livings)
      {
        if (living.Config.IsHelper)
          holdBall.Add(living);
      }
      foreach (Living living in this.m_players.Values)
      {
        if (living.Config.IsHelper || living.IsHoldBall)
          holdBall.Add(living);
      }
      return holdBall;
    }

    public Player FindRandomPlayer()
    {
      List<Player> playerList = new List<Player>();
      Player randomPlayer = (Player) null;
      foreach (Player player in this.m_players.Values)
      {
        if (player.IsLiving)
          playerList.Add(player);
      }
      int index = this.Random.Next(0, playerList.Count);
      if (playerList.Count > 0)
        randomPlayer = playerList[index];
      return randomPlayer;
    }

    public SimpleNpc FindHelper()
    {
      SimpleNpc helper = (SimpleNpc) null;
      foreach (SimpleNpc living in this.m_livings)
      {
        if (living.Config.IsHelper)
          return living;
      }
      return helper;
    }

    public List<Living> FindLivingByID(int ID)
    {
      List<Living> livingById = new List<Living>();
      foreach (SimpleNpc living in this.m_livings)
      {
        if (living.NpcInfo.ID == ID)
          livingById.Add((Living) living);
      }
      return livingById;
    }

    public Living FindRandomLiving()
    {
      List<Living> livingList = new List<Living>();
      Living randomLiving = (Living) null;
      foreach (Living living in this.m_livings)
      {
        if (living.IsLiving)
          livingList.Add(living);
      }
      int index = this.Random.Next(0, livingList.Count);
      if (livingList.Count > 0)
        randomLiving = livingList[index];
      return randomLiving;
    }

    public int FindlivingbyDir(Living npc)
    {
      int num1 = 0;
      int num2 = 0;
      foreach (Player player in this.m_players.Values)
      {
        if (player.IsLiving)
        {
          if (player.X > npc.X)
            ++num2;
          else
            ++num1;
        }
      }
      if (num2 > num1)
        return 1;
      return num2 < num1 ? -1 : -npc.Direction;
    }

    public PhysicalObj[] FindPhysicalObjByName(string name)
    {
      List<PhysicalObj> physicalObjList = new List<PhysicalObj>();
      foreach (PhysicalObj physicalObj in this.m_map.GetAllPhysicalObjSafe())
      {
        if (physicalObj.Name == name)
          physicalObjList.Add(physicalObj);
      }
      return physicalObjList.ToArray();
    }

    public PhysicalObj[] FindPhysicalObjByName(string name, bool CanPenetrate)
    {
      List<PhysicalObj> physicalObjList = new List<PhysicalObj>();
      foreach (PhysicalObj physicalObj in this.m_map.GetAllPhysicalObjSafe())
      {
        if (physicalObj.Name == name && physicalObj.CanPenetrate == CanPenetrate)
          physicalObjList.Add(physicalObj);
      }
      return physicalObjList.ToArray();
    }

    public Player GetFrostPlayerRadom()
    {
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      List<Player> source = new List<Player>();
      foreach (Player player in allFightPlayers)
      {
        if (player.IsFrost)
          source.Add(player);
      }
      if (source.Count <= 0)
        return (Player) null;
      int index = this.Random.Next(0, source.Count);
      return source.ElementAt<Player>(index);
    }

    public void Shuffer<T>(T[] array)
    {
      for (int length = array.Length; length > 1; --length)
      {
        int index = this.Random.Next(length);
        T obj = array[index];
        array[index] = array[length - 1];
        array[length - 1] = obj;
      }
    }

    public virtual bool TakeCard(Player player) => false;

    public virtual bool TakeCard(Player player, int index) => false;

    public override void Pause(int time)
    {
      this.long_1 = Math.Max(this.long_1, TickHelper.GetTickCount() + (long) time);
    }

    public override void Resume() => this.long_1 = 0L;

    public void AddAction(IAction action)
    {
      lock (this.arrayList_0)
        this.arrayList_0.Add((object) action);
    }

    public void AddAction(ArrayList actions)
    {
      lock (this.arrayList_0)
        this.arrayList_0.AddRange((ICollection) actions);
    }

    public void ClearWaitTimer() => this.long_0 = 0L;

    public void WaitTime(int delay)
    {
      this.long_0 = Math.Max(this.long_0, TickHelper.GetTickCount() + (long) delay);
    }

    public long GetWaitTimer() => this.long_0;

    public void Update(long tick)
    {
      if (this.long_1 >= tick)
        return;
      ++this.int_3;
      ArrayList arrayList;
      lock (this.arrayList_0)
      {
        arrayList = (ArrayList) this.arrayList_0.Clone();
        this.arrayList_0.Clear();
      }
      if (arrayList != null && this.GameState != eGameState.Stopped)
      {
        this.CurrentActionCount = arrayList.Count;
        if (arrayList.Count > 0)
        {
          ArrayList actions = new ArrayList();
          foreach (IAction action in arrayList)
          {
            try
            {
              action.Execute(this, tick);
              if (!action.IsFinished(tick))
                actions.Add((object) action);
            }
            catch (Exception ex)
            {
              BaseGame.log.Error((object) "Map update error:", ex);
            }
          }
          this.AddAction(actions);
        }
        else if (this.long_0 < tick)
          this.CheckState(0);
      }
    }

    public List<Player> GetAllFightPlayers()
    {
      List<Player> allFightPlayers = new List<Player>();
      lock (this.m_players)
        allFightPlayers.AddRange((IEnumerable<Player>) this.m_players.Values);
      return allFightPlayers;
    }

    public List<Player> GetAllTeamPlayers(Living living)
    {
      List<Player> allTeamPlayers = new List<Player>();
      lock (this.m_players)
      {
        foreach (Player player in this.m_players.Values)
        {
          if (player.Team == living.Team)
            allTeamPlayers.Add(player);
        }
      }
      return allTeamPlayers;
    }

    public List<Player> GetAllPlayersSameTeam(Living living)
    {
      List<Player> allPlayersSameTeam = new List<Player>();
      lock (this.m_players)
      {
        foreach (Player player in this.m_players.Values)
        {
          if (player.Team == living.Team && player != living)
            allPlayersSameTeam.Add(player);
        }
      }
      return allPlayersSameTeam;
    }

    public List<Player> GetAllTeamPlayerDies(Living living)
    {
      List<Player> allTeamPlayerDies = new List<Player>();
      lock (this.m_players)
      {
        foreach (Player player in this.m_players.Values)
        {
          if (player.Team == living.Team && !player.IsLiving)
            allTeamPlayerDies.Add(player);
        }
      }
      return allTeamPlayerDies;
    }

    public List<Player> GetAllEnemyPlayers(Living living)
    {
      List<Player> allEnemyPlayers = new List<Player>();
      lock (this.m_players)
      {
        foreach (Player player in this.m_players.Values)
        {
          if (player.Team != living.Team)
            allEnemyPlayers.Add(player);
        }
      }
      return allEnemyPlayers;
    }

    public List<Player> GetAllLivingPlayers()
    {
      List<Player> allLivingPlayers = new List<Player>();
      lock (this.m_players)
      {
        foreach (Player player in this.m_players.Values)
        {
          if (player.IsLiving)
            allLivingPlayers.Add(player);
        }
      }
      return allLivingPlayers;
    }

    public bool GetSameTeam()
    {
      bool sameTeam = false;
      Player[] allPlayers = this.GetAllPlayers();
      foreach (Living living in allPlayers)
      {
        if (living.Team != allPlayers[0].Team)
          return false;
        sameTeam = true;
      }
      return sameTeam;
    }

    public Player[] GetAllPlayers() => this.GetAllFightPlayers().ToArray();

    public Player GetPlayer(IGamePlayer gp)
    {
      Player player1 = (Player) null;
      lock (this.m_players)
      {
        foreach (Player player2 in this.m_players.Values)
        {
          if (player2.PlayerDetail == gp)
          {
            player1 = player2;
            break;
          }
        }
      }
      return player1;
    }

    public int GetPlayerCount() => this.GetAllFightPlayers().Count;

    public virtual void SendToAll(GSPacketIn pkg) => this.SendToAll(pkg, (IGamePlayer) null);

    public virtual void SendToAll(GSPacketIn pkg, IGamePlayer except)
    {
      if (pkg.Parameter2 == 0)
        pkg.Parameter2 = this.LifeTime;
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (allFightPlayer.IsActive && allFightPlayer.PlayerDetail != except)
          allFightPlayer.PlayerDetail.SendTCP(pkg);
      }
    }

    public virtual void SendToTeam(GSPacketIn pkg, int team)
    {
      this.SendToTeam(pkg, team, (IGamePlayer) null);
    }

    public virtual void SendToTeam(GSPacketIn pkg, int team, IGamePlayer except)
    {
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (allFightPlayer.IsActive && allFightPlayer.PlayerDetail != except && allFightPlayer.Team == team)
          allFightPlayer.PlayerDetail.SendTCP(pkg);
      }
    }

    public Ball AddBall(Point pos, bool sendToClient)
    {
      Ball ball = new Ball(this.PhysicalId++, "1");
      ball.SetXY(pos);
      this.AddPhysicalObj((PhysicalObj) ball, sendToClient);
      return this.AddBall(ball, sendToClient);
    }

    public Ball AddBall(Ball ball, bool sendToClient)
    {
      this.list_1.Add(ball);
      this.AddPhysicalObj((PhysicalObj) ball, sendToClient);
      return ball;
    }

    public void ClearBall()
    {
      List<Ball> ballList = new List<Ball>();
      foreach (Ball ball in this.list_1)
        ballList.Add(ball);
      foreach (Ball phy in ballList)
      {
        this.list_1.Remove(phy);
        this.RemovePhysicalObj((PhysicalObj) phy, true);
      }
    }

    public void AddTempPoint(int x, int y) => this.list_3.Add(new Point(x, y));

    public Box AddBox(SqlDataProvider.Data.ItemInfo item, Point pos, bool sendToClient)
    {
      Box box = new Box(this.PhysicalId++, "1", item);
      box.SetXY(pos);
      this.AddPhysicalObj((PhysicalObj) box, sendToClient);
      return this.AddBox(box, sendToClient);
    }

    public Box AddBox(Box box, bool sendToClient)
    {
      this.list_2.Add(box);
      this.AddPhysicalObj((PhysicalObj) box, sendToClient);
      return box;
    }

    public void CheckBox()
    {
      List<Box> boxList = new List<Box>();
      foreach (Box box in this.list_2)
      {
        if (!box.IsLiving)
          boxList.Add(box);
      }
      foreach (Box phy in boxList)
      {
        this.list_2.Remove(phy);
        this.RemovePhysicalObj((PhysicalObj) phy, true);
      }
    }

    public List<Box> CreateBox()
    {
      int num1 = this.m_players.Count + 2;
      int num2 = 0;
      List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
      if (this.CurrentTurnTotalDamage > 0)
      {
        num2 = this.m_random.Next(1, 3);
        if (this.list_2.Count + num2 > num1)
          num2 = num1 - this.list_2.Count;
        if (num2 > 0)
          DropInventory.BoxDrop(this.m_roomType, ref info);
      }
      int diedPlayerCount = this.GetDiedPlayerCount();
      int num3 = 0;
      if (diedPlayerCount > 0)
        num3 = this.m_random.Next(diedPlayerCount);
      if (this.list_2.Count + num2 + num3 > num1)
      {
        int num4 = num1 - this.list_2.Count - num2;
      }
      List<Box> box = new List<Box>();
      if (info != null)
      {
        for (int index1 = 0; index1 < this.list_3.Count; ++index1)
        {
          int index2 = this.m_random.Next(this.list_3.Count);
          Point point = this.list_3[index2];
          this.list_3[index2] = this.list_3[index1];
          this.list_3[index1] = point;
        }
        int num5 = Math.Min(info.Count, this.list_3.Count);
        for (int index = 0; index < num5; ++index)
          box.Add(this.AddBox(info[index], this.list_3[index], false));
      }
      this.list_3.Clear();
      return box;
    }

    public void AddLoadingFile(int type, string file, string className)
    {
      if (file == null || className == null)
        return;
      this.list_4.Add(new LoadingFileInfo(type, file, className));
    }

    public void ClearLoadingFiles() => this.list_4.Clear();

    public void AfterUseItem(SqlDataProvider.Data.ItemInfo item)
    {
    }

    internal void method_1()
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 101);
      pkg.WriteInt((int) this.m_roomType);
      pkg.WriteInt((int) this.m_gameType);
      pkg.WriteInt(this.m_timeType);
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      bool flag = this.m_roomType == eRoomType.FightFootballTime;
      pkg.WriteInt(allFightPlayers.Count);
      foreach (Player player in allFightPlayers)
      {
        IGamePlayer playerDetail = player.PlayerDetail;
        pkg.WriteInt(playerDetail.ZoneId);
        pkg.WriteString(playerDetail.ZoneName);
        pkg.WriteInt(playerDetail.PlayerCharacter.ID);
        pkg.WriteString(playerDetail.PlayerCharacter.NickName);
        pkg.WriteBoolean(false);
        pkg.WriteByte(playerDetail.PlayerCharacter.typeVIP);
        pkg.WriteInt(playerDetail.PlayerCharacter.VIPLevel);
        pkg.WriteBoolean(playerDetail.PlayerCharacter.Sex);
        pkg.WriteInt(playerDetail.PlayerCharacter.Hide);
        if (flag)
          pkg.WriteString(playerDetail.GetFightFootballStyle(player.Team));
        else
          pkg.WriteString(playerDetail.PlayerCharacter.Style);
        pkg.WriteString(playerDetail.PlayerCharacter.Colors);
        pkg.WriteString(playerDetail.PlayerCharacter.Skin);
        pkg.WriteInt(playerDetail.PlayerCharacter.Grade);
        pkg.WriteInt(playerDetail.PlayerCharacter.Repute);
        if (flag)
          pkg.WriteInt(70396);
        else if (playerDetail.MainWeapon.IsGold)
          pkg.WriteInt(playerDetail.MainWeapon.GoldEquip.TemplateID);
        else
          pkg.WriteInt(playerDetail.MainWeapon.TemplateID);
        pkg.WriteInt(playerDetail.MainWeapon.RefineryLevel);
        pkg.WriteString(playerDetail.MainWeapon.Template.Name);
        pkg.WriteDateTime(DateTime.Now);
        if (playerDetail.SecondWeapon == null)
          pkg.WriteInt(0);
        else
          pkg.WriteInt(playerDetail.SecondWeapon.TemplateID);
        pkg.WriteInt(0);
        pkg.WriteInt(playerDetail.PlayerCharacter.Nimbus);
        pkg.WriteBoolean(playerDetail.PlayerCharacter.IsShowConsortia);
        pkg.WriteInt(playerDetail.PlayerCharacter.ConsortiaID);
        pkg.WriteString(playerDetail.PlayerCharacter.ConsortiaName);
        pkg.WriteInt(playerDetail.PlayerCharacter.badgeID);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(playerDetail.PlayerCharacter.Win);
        pkg.WriteInt(playerDetail.PlayerCharacter.Total);
        pkg.WriteInt(playerDetail.PlayerCharacter.FightPower);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteString("");
        pkg.WriteInt(playerDetail.PlayerCharacter.AchievementPoint);
        pkg.WriteString(playerDetail.PlayerCharacter.Honor);
        pkg.WriteInt(playerDetail.PlayerCharacter.Offer);
        pkg.WriteBoolean(false);
        pkg.WriteInt(0);
        pkg.WriteBoolean(playerDetail.PlayerCharacter.IsMarried);
        if (playerDetail.PlayerCharacter.IsMarried)
        {
          pkg.WriteInt(playerDetail.PlayerCharacter.SpouseID);
          pkg.WriteString(playerDetail.PlayerCharacter.SpouseName);
        }
        pkg.WriteInt(5);
        pkg.WriteInt(5);
        pkg.WriteInt(5);
        pkg.WriteInt(5);
        pkg.WriteInt(5);
        pkg.WriteInt(5);
        pkg.WriteInt(player.Team);
        pkg.WriteInt(player.Id);
        pkg.WriteInt(player.MaxBlood);
        if (player.Pet != null && !flag)
        {
          pkg.WriteInt(1);
          pkg.WriteInt(player.Pet.Place);
          pkg.WriteInt(player.Pet.TemplateID);
          pkg.WriteInt(player.Pet.ID);
          pkg.WriteString(player.Pet.Name);
          pkg.WriteInt(player.Pet.UserID);
          pkg.WriteInt(player.Pet.Level);
          List<string> skillEquip = player.Pet.GetSkillEquip();
          pkg.WriteInt(skillEquip.Count);
          foreach (string str in skillEquip)
          {
            pkg.WriteInt(int.Parse(str.Split(',')[1]));
            pkg.WriteInt(int.Parse(str.Split(',')[0]));
          }
        }
        else
          goto label_24;
label_21:
        pkg.WriteInt(player.HorseSkillEquip.Length);
        foreach (int val in player.HorseSkillEquip)
          pkg.WriteInt(val);
        continue;
label_24:
        pkg.WriteInt(0);
        goto label_21;
      }
      this.SendToAll(pkg);
    }

    internal void method_2(int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 102);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal void method_3(int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, int_4);
      pkg.Parameter1 = int_4;
      pkg.WriteByte((byte) 138);
      int count = this.Players.Count;
      pkg.WriteInt(count);
      for (int key = 0; key < count; ++key)
      {
        pkg.WriteInt(this.Players[key].PlayerDetail.PlayerCharacter.ID);
        pkg.WriteInt(this.Players[key].PlayerDetail.ZoneId);
        pkg.WriteInt(this.Players[key].Team);
        pkg.WriteInt(this.Players[key].Id);
        pkg.WriteInt(this.Players[key].PlayerDetail.ZoneId);
      }
      this.SendToAll(pkg);
    }

    internal void method_4(Player player_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 12);
      player_0.PlayerDetail.SendTCP(pkg);
    }

    internal void udqMkhsej5(
      Living living_0,
      PetSkillElementInfo petSkillElementInfo_0,
      bool bool_0)
    {
      if (string.IsNullOrEmpty(petSkillElementInfo_0.EffectPic))
        return;
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 145);
      pkg.WriteInt(petSkillElementInfo_0.ID);
      pkg.WriteString("");
      pkg.WriteString("");
      pkg.WriteString(petSkillElementInfo_0.Pic.ToString());
      pkg.WriteString(petSkillElementInfo_0.EffectPic);
      pkg.WriteBoolean(bool_0);
      this.SendToAll(pkg);
    }

    internal void method_5(Living living_0, int int_4, int int_5)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 147);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      (living_0 as Player).PlayerDetail.SendTCP(pkg);
    }

    internal void method_6(Living living_0, int int_4)
    {
      if (this.RoomType != eRoomType.ActivityDungeon)
        return;
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 76);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal void method_7(bool bool_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 160);
      pkg.WriteBoolean(bool_0);
      this.SendToAll(pkg);
    }

    internal void method_8(int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 119);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal bool method_9() => this.RoomType == eRoomType.Freshman;

    internal void method_10(int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 103);
      pkg.WriteInt(int_4);
      pkg.WriteInt(this.m_map.Info.ID);
      pkg.WriteInt(this.list_4.Count);
      foreach (LoadingFileInfo loadingFileInfo in this.list_4)
      {
        pkg.WriteInt(loadingFileInfo.Type);
        pkg.WriteString(loadingFileInfo.Path);
        pkg.WriteString(loadingFileInfo.ClassName);
      }
      if (!this.method_9() && this.RoomType != eRoomType.FightFootballTime)
      {
        GameNeedPetSkillInfo[] gameNeedPetSkill = PetMgr.GetGameNeedPetSkill();
        pkg.WriteInt(gameNeedPetSkill.Length);
        foreach (GameNeedPetSkillInfo needPetSkillInfo in gameNeedPetSkill)
        {
          pkg.WriteString(needPetSkillInfo.Pic.ToString());
          pkg.WriteString(needPetSkillInfo.EffectPic);
        }
      }
      else
        pkg.WriteInt(0);
      this.SendToAll(pkg);
    }

    internal void method_11(
      Living living_0,
      Dictionary<int, PetSkillInfo> PetSkillList,
      Dictionary<int, MountSkillTemplateInfo> HourseSkillList)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 150);
      int count1 = PetSkillList.Count;
      pkg.WriteInt(count1);
      foreach (PetSkillInfo petSkillInfo in PetSkillList.Values)
      {
        pkg.WriteInt(petSkillInfo.ID);
        pkg.WriteInt(petSkillInfo.Turn);
        pkg.WriteInt(0);
      }
      int count2 = HourseSkillList.Count;
      pkg.WriteInt(count2);
      foreach (MountSkillTemplateInfo skillTemplateInfo in HourseSkillList.Values)
      {
        pkg.WriteInt(skillTemplateInfo.ID);
        pkg.WriteInt(skillTemplateInfo.Turn);
        pkg.WriteInt(skillTemplateInfo.Count);
      }
      (living_0 as Player).PlayerDetail.SendTCP(pkg);
    }

    internal void method_12(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 4);
      (living_0 as Player).PlayerDetail.SendTCP(pkg);
    }

    internal void method_13(PhysicalObj physicalObj_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 48);
      pkg.WriteInt(physicalObj_0.Id);
      pkg.WriteInt(physicalObj_0.Type);
      pkg.WriteInt(physicalObj_0.X);
      pkg.WriteInt(physicalObj_0.Y);
      pkg.WriteString(physicalObj_0.Model);
      pkg.WriteString(physicalObj_0.CurrentAction);
      pkg.WriteInt(physicalObj_0.Scale);
      pkg.WriteInt(physicalObj_0.Scale);
      pkg.WriteInt(physicalObj_0.Rotation);
      pkg.WriteInt(physicalObj_0.phyBringToFront);
      pkg.WriteInt(physicalObj_0.typeEffect);
      pkg.WriteInt(physicalObj_0.ActionMapping.Count);
      foreach (string key in physicalObj_0.ActionMapping.Keys)
      {
        pkg.WriteString(key);
        pkg.WriteString(physicalObj_0.ActionMapping[key]);
      }
      this.SendToAll(pkg);
    }

    internal void method_14(PhysicalObj physicalObj_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 68);
      pkg.WriteInt(physicalObj_0.Id);
      pkg.WriteInt(physicalObj_0.Type);
      pkg.WriteInt(physicalObj_0.X);
      pkg.WriteInt(physicalObj_0.Y);
      pkg.WriteString(physicalObj_0.Model);
      pkg.WriteString(physicalObj_0.CurrentAction);
      pkg.WriteInt(physicalObj_0.Scale);
      pkg.WriteInt(physicalObj_0.Rotation);
      this.SendToAll(pkg);
    }

    internal void method_15(Physics physics_0, int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 62);
      pkg.WriteInt(int_4);
      pkg.WriteInt(physics_0.X);
      pkg.WriteInt(physics_0.Y);
      this.SendToAll(pkg);
    }

    internal void method_16(int int_4, int int_5, int int_6)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 62);
      pkg.WriteInt(int_6);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      this.SendToAll(pkg);
    }

    internal void method_17(PhysicalObj physicalObj_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 66);
      pkg.WriteInt(physicalObj_0.Id);
      pkg.WriteString(physicalObj_0.CurrentAction);
      this.SendToAll(pkg);
    }

    internal void method_18(PhysicalObj physicalObj_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 53);
      pkg.WriteInt(physicalObj_0.Id);
      this.SendToAll(pkg);
    }

    internal void method_19(int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 53);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal void method_20(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 64);
      pkg.WriteByte((byte) living_0.Type);
      pkg.WriteInt(living_0.Id);
      pkg.WriteString(living_0.Name);
      pkg.WriteString(living_0.ModelId);
      pkg.WriteString(living_0.ActionStr);
      pkg.WriteInt(living_0.X);
      pkg.WriteInt(living_0.Y);
      pkg.WriteInt(living_0.Blood);
      pkg.WriteInt(living_0.MaxBlood);
      pkg.WriteInt(living_0.Team);
      pkg.WriteByte((byte) living_0.Direction);
      pkg.WriteByte(living_0.Config.isBotom);
      pkg.WriteBoolean(living_0.Config.isShowBlood);
      pkg.WriteBoolean(living_0.Config.isShowSmallMapPoint);
      pkg.WriteInt(0);
      pkg.WriteInt(0);
      pkg.WriteBoolean(living_0.IsFrost);
      pkg.WriteBoolean(living_0.IsHide);
      pkg.WriteBoolean(living_0.IsNoHole);
      pkg.WriteBoolean(false);
      pkg.WriteInt(0);
      if (this.RoomType == eRoomType.ActivityDungeon && living_0 is SimpleBoss)
        pkg.WriteInt((living_0 as SimpleBoss).NpcInfo.ID);
      this.SendToAll(pkg);
    }

    internal void method_21(
      Player player_0,
      int int_4,
      int int_5,
      int int_6,
      byte byte_0,
      bool bool_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 9);
      pkg.WriteBoolean(false);
      pkg.WriteByte((byte) int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteByte(byte_0);
      pkg.WriteBoolean(bool_0);
      if (int_4 == 2)
      {
        pkg.WriteInt(this.list_2.Count);
        foreach (Box box in this.list_2)
        {
          pkg.WriteInt(box.X);
          pkg.WriteInt(box.Y);
        }
      }
      this.SendToAll(pkg);
    }

    internal void method_22(Player player_0, int int_4, int int_5, int int_6, byte byte_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.PlayerDetail.PlayerCharacter.ID);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 9);
      pkg.WriteBoolean(false);
      pkg.WriteByte((byte) int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteByte(byte_0);
      pkg.WriteBoolean(player_0.IsLiving);
      if (int_4 == 2)
      {
        pkg.WriteInt(this.list_2.Count);
        foreach (Box box in this.list_2)
        {
          pkg.WriteInt(box.X);
          pkg.WriteInt(box.Y);
        }
      }
      this.SendToAll(pkg, player_0.PlayerDetail);
    }

    internal void vAwYovJgkr(
      Living living_0,
      int int_4,
      int int_5,
      int int_6,
      int int_7,
      string string_0,
      int int_8,
      string string_1)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 55);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteInt(int_7);
      pkg.WriteInt(int_8);
      pkg.WriteString(!string.IsNullOrEmpty(string_0) ? string_0 : "");
      pkg.WriteString(string_1);
      this.SendToAll(pkg);
    }

    internal void method_23(Living living_0, string string_0, int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 59);
      pkg.WriteString(string_0);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal void method_24(
      Living living_0,
      int int_4,
      int int_5,
      int int_6,
      string string_0,
      int int_7)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 56);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteString(!string.IsNullOrEmpty(string_0) ? string_0 : "");
      pkg.WriteInt(int_7);
      this.SendToAll(pkg);
    }

    internal void method_25(
      Living living_0,
      int int_4,
      int int_5,
      int int_6,
      string string_0,
      int int_7)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 57);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteString(!string.IsNullOrEmpty(string_0) ? string_0 : "");
      pkg.WriteInt(int_7);
      this.SendToAll(pkg);
    }

    internal void method_26(
      Living living_0,
      Living living_1,
      int int_4,
      string string_0,
      int int_5,
      int int_6)
    {
      int val = 0;
      if (living_1 is Player)
        val = (living_1 as Player).Dander;
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 58);
      pkg.WriteString(!string.IsNullOrEmpty(string_0) ? string_0 : "");
      pkg.WriteInt(int_5);
      for (int index = 1; index <= int_5; ++index)
      {
        pkg.WriteInt(living_1.Id);
        pkg.WriteInt(int_4);
        pkg.WriteInt(living_1.Blood);
        pkg.WriteInt(val);
        pkg.WriteInt(int_6);
      }
      this.SendToAll(pkg);
    }

    internal void method_27(Living living_0, string string_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 60);
      pkg.WriteString(string_0);
      this.SendToAll(pkg);
    }

    internal void method_28(Living living_0, int int_4, int int_5)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 11);
      pkg.WriteByte((byte) int_4);
      pkg.WriteInt(living_0.Blood);
      pkg.WriteInt(int_5);
      this.SendToAll(pkg);
    }

    internal void method_29(TurnedLiving turnedLiving_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, turnedLiving_0.Id);
      pkg.Parameter1 = turnedLiving_0.Id;
      pkg.WriteByte((byte) 14);
      pkg.WriteInt(turnedLiving_0.Dander);
      this.SendToAll(pkg);
    }

    internal void method_30(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 33);
      pkg.WriteBoolean(living_0.IsFrost);
      this.SendToAll(pkg);
    }

    internal void method_31(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 82);
      pkg.WriteBoolean(living_0.IsNoHole);
      this.SendToAll(pkg);
    }

    internal void method_32(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 35);
      pkg.WriteBoolean(living_0.IsHide);
      this.SendToAll(pkg);
    }

    internal void method_33(Living living_0, string string_0, string string_1)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 41);
      pkg.WriteString(string_0);
      pkg.WriteString(string_1);
      this.SendToAll(pkg);
    }

    internal void method_34(Living living_0, string string_0, string string_1)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 41);
      pkg.WriteString(string_0);
      pkg.WriteString(string_1);
      if (!(living_0 is Player))
        return;
      ((Player) living_0).PlayerDetail.SendTCP(pkg);
    }

    internal void method_35(Player player_0, int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.WriteByte((byte) 80);
      pkg.WriteInt(player_0.Id);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal void method_36(Player player_0, long long_2, int int_4, int int_5)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.WriteByte((byte) 39);
      pkg.WriteInt(player_0.Id);
      pkg.WriteLong(long_2);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      this.SendToAll(pkg);
    }

    internal void method_37(Player player_0, int int_4, int int_5, string string_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 85);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      pkg.WriteString(string_0);
      this.SendToAll(pkg);
    }

    internal void method_38(Player player_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 46);
      pkg.WriteByte((byte) player_0.ShootCount);
      this.SendToAll(pkg);
    }

    internal void method_39(Player player_0, bool bool_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 20);
      pkg.WriteBoolean(bool_0);
      pkg.WriteInt(player_0.CurrentBall.ID);
      this.SendToAll(pkg);
    }

    internal void method_40(Living living_0, int int_4, int int_5, string string_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.WriteByte((byte) 49);
      pkg.WriteByte((byte) int_4);
      pkg.WriteByte((byte) int_5);
      pkg.WriteString(string_0);
      this.SendToAll(pkg);
    }

    internal void method_41(Living living_0, Ball ball_0)
    {
      string currentAction = ball_0.CurrentAction;
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.WriteByte((byte) 223);
      pkg.WriteInt(ball_0.Id);
      pkg.WriteString(currentAction);
      pkg.WriteString(ball_0.ActionMapping[currentAction]);
      this.SendToAll(pkg);
    }

    internal void method_42(Living living_0, List<int> listTemplate)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.WriteByte((byte) 136);
      pkg.WriteInt(listTemplate.Count);
      foreach (int val in listTemplate)
        pkg.WriteInt(val);
      this.SendToAll(pkg);
    }

    internal void method_43(float float_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 38);
      int num = (int) ((double) float_0 * 10.0);
      pkg.WriteInt(num);
      pkg.WriteBoolean(num > 0);
      pkg.WriteByte(this.GetVane(num, 1));
      pkg.WriteByte(this.GetVane(num, 2));
      pkg.WriteByte(this.GetVane(num, 3));
      this.SendToAll(pkg);
    }

    public byte GetVane(int Wind, int param)
    {
      int wind = Math.Abs(Wind);
      switch (param)
      {
        case 1:
          return WindMgr.GetWindID(wind, 1);
        case 3:
          return WindMgr.GetWindID(wind, 3);
        default:
          return 0;
      }
    }

    public void VaneLoading()
    {
      foreach (WindInfo windInfo in WindMgr.GetWind())
        this.method_44((byte) windInfo.WindID, windInfo.WindPic);
    }

    internal void method_44(byte byte_0, byte[] byte_1)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 241);
      pkg.WriteByte(byte_0);
      pkg.Write(byte_1);
      this.SendToAll(pkg);
    }

    internal void method_45(Living living_0, int int_4, int int_5, int int_6)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.WriteByte((byte) 39);
      pkg.WriteInt(living_0.Id);
      pkg.WriteLong((long) int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      this.SendToAll(pkg);
    }

    internal void method_46(Player player_0, int int_4, int int_5)
    {
      this.method_47(player_0, player_0.PetEffects.CurrentUseSkill, player_0.PetEffects.IsPetUseSkill, int_4, int_5);
    }

    internal void method_47(Player player_0, int int_4, bool bool_0, int int_5, int int_6)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 144);
      pkg.WriteInt(int_4);
      pkg.WriteBoolean(bool_0);
      pkg.WriteInt(int_5);
      if (int_5 == 2)
        pkg.WriteInt(int_6);
      this.SendToAll(pkg);
    }

    internal void method_48(Player player_0, int int_4, int int_5)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 72);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      this.SendToAll(pkg);
    }

    internal void method_49(Player player_0, int int_4, bool bool_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 79);
      pkg.WriteInt(int_4);
      pkg.WriteBoolean(bool_0);
      pkg.WriteInt(player_0.Id);
      if (int_4 == 1)
        pkg.WriteDateTime(DateTime.Now.AddMilliseconds(9000.0));
      this.SendToAll(pkg);
    }

    internal void method_50(Player player_0, int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 84);
      pkg.WriteInt(int_4);
      player_0.PlayerDetail.SendTCP(pkg);
    }

    internal void method_51(Player player_0, int int_4, int int_5, int int_6)
    {
      this.method_52((Living) player_0, int_4, int_5, int_6, player_0);
    }

    internal void method_52(Living living_0, int int_4, int int_5, int int_6, Player player_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 32);
      pkg.WriteByte((byte) int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteInt(player_0.Id);
      pkg.WriteBoolean(int_6 == 10017);
      this.SendToAll(pkg);
    }

    internal void method_53(Player player_0, int int_4, int int_5, int int_6)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 98);
      pkg.WriteBoolean(false);
      pkg.WriteByte((byte) int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      this.SendToAll(pkg);
    }

    internal void method_54(Player player_0, int int_4, int int_5, int int_6)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, player_0.Id);
      pkg.Parameter1 = player_0.Id;
      pkg.WriteByte((byte) 98);
      pkg.WriteBoolean(false);
      pkg.WriteByte((byte) int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      pkg.WriteBoolean(false);
      this.SendToAll(pkg);
    }

    public int getTurnTime()
    {
      switch (this.m_timeType)
      {
        case 1:
          return 8;
        case 2:
          return 10;
        case 3:
          return 12;
        case 4:
          return 16;
        case 5:
          return 21;
        case 6:
          return 31;
        default:
          return -1;
      }
    }

    internal void method_55(Living living_0, BaseGame baseGame_0, List<Box> newBoxes)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 6);
      int Wind = (int) ((double) this.m_map.wind * 10.0);
      pkg.WriteBoolean(Wind > 0);
      pkg.WriteByte(this.GetVane(Wind, 1));
      pkg.WriteByte(this.GetVane(Wind, 2));
      pkg.WriteByte(this.GetVane(Wind, 3));
      pkg.WriteBoolean(living_0.IsHide);
      pkg.WriteInt(this.getTurnTime());
      pkg.WriteInt(newBoxes.Count);
      foreach (Box newBox in newBoxes)
      {
        pkg.WriteInt(newBox.Id);
        pkg.WriteInt(newBox.X);
        pkg.WriteInt(newBox.Y);
        pkg.WriteInt(newBox.Type);
      }
      List<Player> allFightPlayers = baseGame_0.GetAllFightPlayers();
      pkg.WriteInt(allFightPlayers.Count);
      foreach (Player player in allFightPlayers)
      {
        pkg.WriteInt(player.Id);
        pkg.WriteBoolean(player.IsLiving);
        pkg.WriteInt(player.X);
        pkg.WriteInt(player.Y);
        pkg.WriteInt(player.Blood);
        pkg.WriteBoolean(player.IsNoHole);
        pkg.WriteInt(player.Energy);
        pkg.WriteInt(player.psychic);
        pkg.WriteInt(player.Dander);
        if (player.Pet == null)
        {
          pkg.WriteInt(0);
          pkg.WriteInt(0);
        }
        else
        {
          pkg.WriteInt(player.PetMaxMP);
          pkg.WriteInt(player.PetMP);
        }
        pkg.WriteInt(player.ShootCount);
        pkg.WriteInt(player.flyCount);
      }
      pkg.WriteInt(baseGame_0.TurnIndex);
      pkg.WriteBoolean(false);
      if (this.RoomType == eRoomType.FightFootballTime)
        pkg.WriteInt(baseGame_0.nextPlayerId);
      this.SendToAll(pkg);
    }

    internal void method_56(Living living_0, BaseGame baseGame_0, List<Box> newBoxes)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, living_0.Id);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 6);
      int Wind = (int) ((double) this.m_map.wind * 10.0);
      pkg.WriteBoolean(Wind > 0);
      pkg.WriteByte(this.GetVane(Wind, 1));
      pkg.WriteByte(this.GetVane(Wind, 2));
      pkg.WriteByte(this.GetVane(Wind, 3));
      pkg.WriteBoolean(living_0.IsHide);
      pkg.WriteInt(this.getTurnTime());
      pkg.WriteInt(newBoxes.Count);
      foreach (Box newBox in newBoxes)
      {
        pkg.WriteInt(newBox.Id);
        pkg.WriteInt(newBox.X);
        pkg.WriteInt(newBox.Y);
        pkg.WriteInt(newBox.Type);
      }
      pkg.WriteInt(1);
      pkg.WriteInt(living_0.Id);
      pkg.WriteBoolean(living_0.IsLiving);
      pkg.WriteInt(living_0.X);
      pkg.WriteInt(living_0.Y);
      pkg.WriteInt(living_0.Blood);
      pkg.WriteBoolean(living_0.IsNoHole);
      pkg.WriteInt(((Player) living_0).Energy);
      pkg.WriteInt(((TurnedLiving) living_0).psychic);
      pkg.WriteInt(((TurnedLiving) living_0).Dander);
      if (((Player) living_0).Pet == null)
      {
        pkg.WriteInt(0);
        pkg.WriteInt(0);
      }
      else
      {
        pkg.WriteInt(((TurnedLiving) living_0).PetMaxMP);
        pkg.WriteInt(((TurnedLiving) living_0).PetMP);
      }
      pkg.WriteInt(((Player) living_0).ShootCount);
      pkg.WriteInt(((Player) living_0).flyCount);
      pkg.WriteInt(baseGame_0.TurnIndex);
      pkg.WriteBoolean(false);
      ((Player) living_0).PlayerDetail.SendTCP(pkg);
    }

    internal void vrgYhrgvPg(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 7);
      pkg.WriteInt(living_0.Direction);
      this.SendToAll(pkg);
    }

    internal void method_57(Living living_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 118);
      pkg.WriteInt(living_0.State);
      this.SendToAll(pkg);
    }

    internal void method_58(Living living_0, string string_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 3);
      pkg.WriteInt(3);
      pkg.WriteString(string_0);
      this.SendToAll(pkg);
    }

    internal void method_59(
      IGamePlayer igamePlayer_0,
      string string_0,
      string string_1,
      int int_4)
    {
      if (string_0 != null)
      {
        GSPacketIn pkg = new GSPacketIn((short) 3);
        pkg.WriteInt(int_4);
        pkg.WriteString(string_0);
        igamePlayer_0.SendTCP(pkg);
      }
      if (string_1 == null)
        return;
      GSPacketIn pkg1 = new GSPacketIn((short) 3);
      pkg1.WriteInt(int_4);
      pkg1.WriteString(string_1);
      this.SendToAll(pkg1, igamePlayer_0);
    }

    internal void method_60(Living living_0, int int_4, int int_5, int int_6)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 238);
      pkg.WriteInt(int_4);
      pkg.WriteInt(int_5);
      pkg.WriteInt(int_6);
      this.SendToAll(pkg);
    }

    internal void method_61(Living living_0, int int_4, bool bool_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 128);
      pkg.WriteInt(int_4);
      pkg.WriteBoolean(bool_0);
      this.SendToAll(pkg);
    }

    internal void method_62(Player player_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 94, player_0.PlayerDetail.PlayerCharacter.ID);
      pkg.WriteByte((byte) 5);
      pkg.WriteInt(player_0.PlayerDetail.ZoneId);
      this.SendToAll(pkg);
    }

    internal void method_63(Living living_0, int int_4)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.Parameter1 = living_0.Id;
      pkg.WriteByte((byte) 129);
      pkg.WriteBoolean(true);
      pkg.WriteInt(int_4);
      this.SendToAll(pkg);
    }

    internal void method_64()
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 131);
      pkg.WriteInt(this.int_3);
      this.SendToAll(pkg);
    }

    protected void OnGameOverred()
    {
      if (this.gameEventHandle_2 == null)
        return;
      this.gameEventHandle_2((AbstractGame) this);
    }

    protected void OnBeginNewTurn()
    {
      if (this.gameEventHandle_3 == null)
        return;
      this.gameEventHandle_3((AbstractGame) this);
    }

    public void OnGameOverLog(
      int _roomId,
      eRoomType _roomType,
      eGameType _fightType,
      int _changeTeam,
      DateTime _playBegin,
      DateTime _playEnd,
      int _userCount,
      int _mapId,
      string _teamA,
      string _teamB,
      string _playResult,
      int _winTeam,
      string BossWar)
    {
      if (this.iOqupaYcDc == null)
        return;
      this.iOqupaYcDc(_roomId, _roomType, _fightType, _changeTeam, _playBegin, _playEnd, _userCount, _mapId, _teamA, _teamB, _playResult, _winTeam, this.BossWarField);
    }

    public void OnGameNpcDie(int Id)
    {
      if (this.gameNpcDieEventHandle_0 == null)
        return;
      this.gameNpcDieEventHandle_0(Id);
    }

    public override string ToString()
    {
      return string.Format("Id:{0},player:{1},state:{2},current:{3},turnIndex:{4},actions:{5}", (object) this.Id, (object) this.PlayerCount, (object) this.GameState, (object) this.CurrentLiving, (object) this.m_turnIndex, (object) this.arrayList_0.Count);
    }

    public delegate void GameOverLogEventHandle(
      int roomId,
      eRoomType roomType,
      eGameType fightType,
      int changeTeam,
      DateTime playBegin,
      DateTime playEnd,
      int userCount,
      int mapId,
      string teamA,
      string teamB,
      string playResult,
      int winTeam,
      string BossWar);

    public delegate void GameNpcDieEventHandle(int NpcId);
  }
}
