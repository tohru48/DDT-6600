// Decompiled with JetBrains decompiler
// Type: Game.Logic.PVEGame
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.AI.Game;
using Game.Logic.AI.Mission;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Reflection;
using System.Text;

#nullable disable
namespace Game.Logic
{
  public class PVEGame : BaseGame
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private APVEGameControl apvegameControl_0;
    private AMissionControl amissionControl_0;
    public int SessionId;
    public int PreSessionId;
    public bool IsWin;
    public bool IsKillWorldBoss;
    public bool CanEnterGate;
    public bool CanShowBigBox;
    public int TotalMissionCount;
    public int TotalCount;
    public int TotalTurn;
    public int Param1;
    public int Param2;
    public int Param3;
    public int Param4;
    public string Pic;
    public int TotalKillCount;
    public bool IsMissBall;
    public int TotalGoal;
    public bool IsGoal;
    public bool PassBallActive;
    public bool defendFail;
    public bool CanBeginNextProtect;
    public double TotalNpcExperience;
    public double TotalNpcGrade;
    private int int_4;
    private PveInfo pveInfo_0;
    private List<string> list_5;
    public Dictionary<int, MissionInfo> Misssions;
    private MapPoint mapPoint_0;
    public int WantTryAgain;
    public long WorldbossBood;
    public long AllWorldDameBoss;
    private eHardLevel eHardLevel_0;
    private DateTime dateTime_0;
    private string string_0;
    private MissionInfo missionInfo_0;
    private List<int> list_6;
    public int[] BossCards;
    private int int_5;
    private int int_6;

    public MissionInfo MissionInfo
    {
      get => this.missionInfo_0;
      set => this.missionInfo_0 = value;
    }

    public Player CurrentPlayer => this.m_currentLiving as Player;

    public TurnedLiving CurrentTurnLiving => this.m_currentLiving;

    public List<int> MapHistoryIds
    {
      get => this.list_6;
      set => this.list_6 = value;
    }

    public eHardLevel HandLevel => this.eHardLevel_0;

    public MapPoint MapPos => this.mapPoint_0;

    public string IsBossWar
    {
      get => this.string_0;
      set => this.string_0 = value;
    }

    public List<string> GameOverResources => this.list_5;

    public int BossCardCount
    {
      get => this.int_5;
      set
      {
        if (value <= 0)
          return;
        this.BossCards = new int[9];
        this.int_5 = value;
      }
    }

    public int PveGameDelay
    {
      get => this.int_6;
      set => this.int_6 = value;
    }

    public PVEGame(
      int id,
      int roomId,
      PveInfo info,
      List<IGamePlayer> players,
      Map map,
      eRoomType roomType,
      eGameType gameType,
      int timeType,
      eHardLevel hardLevel,
      int currentFloor)
      : base(id, roomId, map, roomType, gameType, timeType)
    {
      foreach (IGamePlayer player1 in players)
      {
        IGamePlayer gp = player1;
        Player player2 = new Player(player1, this.PhysicalId++, (BaseGame) this, 1, player1.PlayerCharacter.hp);
        player2.Direction = this.m_random.Next(0, 1) == 0 ? 1 : -1;
        Player fp = player2;
        this.AddPlayer(gp, fp);
        this.WorldbossBood = player1.WorldbossBood;
        this.AllWorldDameBoss = player1.AllWorldDameBoss;
      }
      this.pveInfo_0 = info;
      this.int_4 = players.Count;
      this.TotalKillCount = 0;
      this.TotalNpcGrade = 0.0;
      this.TotalNpcExperience = 0.0;
      this.TotalHurt = 0;
      this.string_0 = "";
      this.WantTryAgain = 0;
      this.loadBossID = currentFloor;
      this.SessionId = currentFloor <= 0 ? 0 : currentFloor - 1;
      this.PreSessionId = 0;
      this.list_5 = new List<string>();
      this.Misssions = new Dictionary<int, MissionInfo>();
      this.list_6 = new List<int>();
      this.eHardLevel_0 = hardLevel;
      string name = this.method_65(info, hardLevel);
      this.apvegameControl_0 = ScriptMgr.CreateInstance(name) as APVEGameControl;
      if (this.apvegameControl_0 == null)
      {
        PVEGame.ilog_0.ErrorFormat("Can't create game ai :{0}", (object) name);
        this.apvegameControl_0 = (APVEGameControl) GControl0.Simple;
      }
      this.apvegameControl_0.Game = this;
      this.apvegameControl_0.OnCreated();
      this.amissionControl_0 = (AMissionControl) SimpleMissionControl.Simple;
      this.dateTime_0 = DateTime.Now;
      this.int_5 = 0;
      this.IsMissBall = false;
    }

    private string method_65(PveInfo pveInfo_1, eHardLevel eHardLevel_1)
    {
      string empty = string.Empty;
      string str;
      switch (eHardLevel_1)
      {
        case eHardLevel.Easy:
          str = pveInfo_1.SimpleGameScript;
          break;
        case eHardLevel.Normal:
          str = pveInfo_1.NormalGameScript;
          break;
        case eHardLevel.Hard:
          str = pveInfo_1.HardGameScript;
          break;
        case eHardLevel.Terror:
          str = pveInfo_1.TerrorGameScript;
          break;
        case eHardLevel.Epic:
          str = pveInfo_1.EpicGameScript;
          break;
        default:
          str = pveInfo_1.SimpleGameScript;
          break;
      }
      return str;
    }

    public string GetMissionIdStr(string missionIds, int randomCount)
    {
      if (string.IsNullOrEmpty(missionIds))
        return "";
      string[] strArray = missionIds.Split(',');
      if (strArray.Length < randomCount)
        return "";
      List<string> stringList = new List<string>();
      int length = strArray.Length;
      int num = 0;
      while (num < randomCount)
      {
        int index = this.Random.Next(length);
        string str = strArray[index];
        if (!stringList.Contains(str))
        {
          stringList.Add(str);
          ++num;
        }
      }
      StringBuilder stringBuilder = new StringBuilder();
      foreach (string str in stringList)
        stringBuilder.Append(str).Append(",");
      return stringBuilder.Remove(stringBuilder.Length - 1, 1).ToString();
    }

    public void SetupMissions(string missionIds)
    {
      if (string.IsNullOrEmpty(missionIds))
        return;
      if (this.RoomType == eRoomType.Dungeon && this.SessionId != 0)
      {
        this.Misssions.Add(1, MissionInfoMgr.GetMissionInfo(int.Parse(missionIds.Split(',')[this.SessionId])));
        this.SessionId = 0;
      }
      else
      {
        int key = 0;
        string str = missionIds;
        char[] chArray = new char[1]{ ',' };
        foreach (string s in str.Split(chArray))
        {
          ++key;
          MissionInfo missionInfo = MissionInfoMgr.GetMissionInfo(int.Parse(s));
          this.Misssions.Add(key, missionInfo);
        }
      }
    }

    public LivingConfig BaseLivingConfig()
    {
      return new LivingConfig()
      {
        isBotom = 1,
        HasTurn = true,
        isShowBlood = true,
        isShowSmallMapPoint = true,
        ReduceBloodStart = 1
      };
    }

    public SimpleNpc CreateNpc(int npcId, int x, int y, int type, int direction)
    {
      return this.CreateNpc(npcId, x, y, type, direction, this.BaseLivingConfig());
    }

    public SimpleNpc CreateNpc(
      int npcId,
      int x,
      int y,
      int type,
      int direction,
      LivingConfig config)
    {
      NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
      SimpleNpc npc = new SimpleNpc(this.PhysicalId++, (BaseGame) this, npcInfoById, type, direction);
      if (config != null)
        npc.Config = config;
      if (npc.Config.ReduceBloodStart > 1)
        npc.Blood = npcInfoById.Blood / npc.Config.ReduceBloodStart;
      else
        npc.Reset();
      npc.SetXY(x, y);
      this.AddLiving((Living) npc);
      npc.StartFalling(false);
      return npc;
    }

    public SimpleNpc CreateNpc(int npcId, int type, int direction)
    {
      NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
      SimpleNpc npc = new SimpleNpc(this.PhysicalId++, (BaseGame) this, npcInfoById, type, direction);
      Point playerPoint = this.GetPlayerPoint(this.mapPoint_0, npcInfoById.Camp);
      npc.Reset();
      npc.SetXY(playerPoint);
      this.AddLiving((Living) npc);
      npc.StartMoving();
      return npc;
    }

    public SimpleBoss CreateBoss(
      int npcId,
      int x,
      int y,
      int direction,
      int type,
      string action)
    {
      return this.CreateBoss(npcId, x, y, direction, type, action, this.BaseLivingConfig());
    }

    public SimpleBoss CreateBoss(
      int npcId,
      int x,
      int y,
      int direction,
      int type,
      string action,
      LivingConfig config)
    {
      NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
      SimpleBoss boss = new SimpleBoss(this.PhysicalId++, (BaseGame) this, npcInfoById, direction, type, action);
      if (config != null)
        boss.Config = config;
      if (boss.Config.ReduceBloodStart > 1)
      {
        boss.Blood = npcInfoById.Blood / boss.Config.ReduceBloodStart;
      }
      else
      {
        boss.Reset();
        if (boss.Config.IsWorldBoss && this.WorldbossBood < (long) int.MaxValue)
          boss.Blood = (int) this.WorldbossBood;
        if (boss.Config.isConsortiaBoss)
          boss.Blood -= (int) this.AllWorldDameBoss;
      }
      boss.SetXY(x, y);
      this.AddLiving((Living) boss);
      boss.StartFalling(false);
      return boss;
    }

    public Box CreateBox(int x, int y, string model, SqlDataProvider.Data.ItemInfo item)
    {
      Box box = new Box(this.PhysicalId++, model, item);
      box.SetXY(x, y);
      this.m_map.AddPhysical((Physics) box);
      this.AddBox(box, true);
      return box;
    }

    public Ball CreateBall(int x, int y, string action)
    {
      Ball ball = new Ball(this.PhysicalId++, action);
      ball.SetXY(x, y);
      this.m_map.AddPhysical((Physics) ball);
      this.AddBall(ball, true);
      return ball;
    }

    public void SendGameFocus(Physics p, int delay, int finishTime)
    {
      this.AddAction((IAction) new FocusAction(p, 1, delay, finishTime));
    }

    public void SendGameFocus(int x, int y, int delay, int finishTime)
    {
      this.AddAction((IAction) new FocusLocalAction(x, y, 1, delay, finishTime));
    }

    public PhysicalObj CreatePhysicalObj(
      int x,
      int y,
      string name,
      string model,
      string defaultAction,
      int scale,
      int rotation)
    {
      PhysicalObj phy = new PhysicalObj(this.PhysicalId++, name, model, defaultAction, scale, rotation);
      phy.SetXY(x, y);
      this.AddPhysicalObj(phy, true);
      return phy;
    }

    public Layer Createlayer(
      int x,
      int y,
      string name,
      string model,
      string defaultAction,
      int scale,
      int rotation)
    {
      Layer phy = new Layer(this.PhysicalId++, name, model, defaultAction, scale, rotation);
      phy.SetXY(x, y);
      this.AddPhysicalObj((PhysicalObj) phy, true);
      return phy;
    }

    public Layer CreateTip(
      int x,
      int y,
      string name,
      string model,
      string defaultAction,
      int scale,
      int rotation)
    {
      Layer phy = new Layer(this.PhysicalId++, name, model, defaultAction, scale, rotation);
      phy.SetXY(x, y);
      this.AddPhysicalTip((PhysicalObj) phy, true);
      return phy;
    }

    public void CreateGate(bool isEnter) => this.CanEnterGate = isEnter;

    public void ClearMissionData()
    {
      foreach (Physics living in this.m_livings)
        living.Dispose();
      this.m_livings.Clear();
      List<TurnedLiving> turnedLivingList = new List<TurnedLiving>();
      foreach (TurnedLiving turn in this.TurnQueue)
      {
        if (turn is Player)
        {
          if (turn.IsLiving)
            turnedLivingList.Add(turn);
        }
        else
          turn.Dispose();
      }
      this.TurnQueue.Clear();
      foreach (TurnedLiving turnedLiving in turnedLivingList)
        this.TurnQueue.Add(turnedLiving);
      if (this.m_map == null)
        return;
      foreach (Physics physics in this.m_map.GetAllPhysicalObjSafe())
        physics.Dispose();
    }

    public void AddAllPlayerToTurn()
    {
      foreach (TurnedLiving turnedLiving in this.Players.Values)
        this.TurnQueue.Add(turnedLiving);
    }

    public override void AddLiving(Living living)
    {
      base.AddLiving(living);
      living.Died += new LivingEventHandle(this.method_66);
    }

    private void method_66(Living living_0)
    {
      if (this.CurrentLiving == null || !(this.CurrentLiving is Player) || living_0 is Player || living_0 == this.CurrentLiving)
        return;
      ++this.TotalKillCount;
      this.TotalNpcExperience += (double) living_0.Experience;
      this.TotalNpcGrade += (double) living_0.Grade;
    }

    public override void MissionStart(IGamePlayer host)
    {
      if (this.GameState != eGameState.SessionPrepared && this.GameState != eGameState.GameOver)
        return;
      foreach (Player player in this.Players.Values)
        player.Ready = true;
      this.CheckState(0);
    }

    public override bool CanAddPlayer()
    {
      bool flag;
      lock (this.m_players)
        flag = this.GameState == eGameState.SessionPrepared && this.m_players.Count < 4;
      return flag;
    }

    public override Player AddPlayer(IGamePlayer gp)
    {
      if (!this.CanAddPlayer())
        return (Player) null;
      Player player = new Player(gp, this.PhysicalId++, (BaseGame) this, 1, gp.PlayerCharacter.hp);
      player.Direction = this.m_random.Next(0, 1) == 0 ? 1 : -1;
      this.AddPlayer(gp, player);
      this.method_75(this, gp);
      this.SendPlayerInfoInGame(this, gp, player);
      return player;
    }

    public override Player RemovePlayer(IGamePlayer gp, bool isKick)
    {
      Player player = this.GetPlayer(gp);
      if (player != null)
      {
        player.PlayerDetail.ClearFightBuffOneMatch();
        player.PlayerDetail.ClearPropItem();
        player.PlayerDetail.ResetRoom(false, true);
        base.RemovePlayer(gp, isKick);
      }
      return player;
    }

    public void LoadResources(int[] npcIds)
    {
      if (npcIds == null || npcIds.Length == 0)
        return;
      for (int index = 0; index < npcIds.Length; ++index)
      {
        NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcIds[index]);
        if (npcInfoById == null)
          PVEGame.ilog_0.Error((object) "LoadResources npcInfo resoure is not exits");
        else
          this.AddLoadingFile(2, npcInfoById.ResourcesPath, npcInfoById.ModelID);
      }
    }

    public void LoadNpcGameOverResources(int[] npcIds)
    {
      if (npcIds == null || npcIds.Length == 0)
        return;
      for (int index = 0; index < npcIds.Length; ++index)
      {
        NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcIds[index]);
        if (npcInfoById == null)
          PVEGame.ilog_0.Error((object) "LoadGameOverResources npcInfo resoure is not exits");
        else
          this.list_5.Add(npcInfoById.ModelID);
      }
    }

    public void Prepare()
    {
      if (this.GameState != eGameState.Inited)
        return;
      this.m_gameState = eGameState.Prepared;
      this.method_1();
      this.CheckState(0);
      try
      {
        this.apvegameControl_0.OnPrepated();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
    }

    public void PrepareNewSession()
    {
      if (this.GameState != eGameState.Prepared && this.GameState != eGameState.GameOver && this.GameState != eGameState.ALLSessionStopped)
        return;
      this.m_gameState = eGameState.SessionPrepared;
      ++this.SessionId;
      this.ClearLoadingFiles();
      this.ClearMissionData();
      this.list_5.Clear();
      this.WantTryAgain = 0;
      this.missionInfo_0 = this.Misssions[this.SessionId];
      this.int_6 = this.missionInfo_0.Delay;
      this.TotalCount = this.missionInfo_0.TotalCount;
      this.TotalTurn = this.missionInfo_0.TotalTurn;
      this.Param1 = this.missionInfo_0.Param1;
      this.Param2 = this.missionInfo_0.Param2;
      this.Param3 = -1;
      this.Param4 = -1;
      this.amissionControl_0 = ScriptMgr.CreateInstance(this.missionInfo_0.Script) as AMissionControl;
      if (this.amissionControl_0 == null)
      {
        PVEGame.ilog_0.ErrorFormat("Can't create game mission ai :{0}", (object) this.missionInfo_0.Script);
        this.amissionControl_0 = (AMissionControl) SimpleMissionControl.Simple;
      }
      if (this.RoomType == eRoomType.Dungeon && this.Misssions.ContainsKey(1 + this.SessionId))
      {
        this.Pic = string.Format("show{0}.jpg", (object) this.SessionId);
        foreach (Player allFightPlayer in this.GetAllFightPlayers())
          allFightPlayer.PlayerDetail.UpdateBarrier(this.SessionId, this.Pic);
      }
      this.amissionControl_0.Game = this;
      try
      {
        this.amissionControl_0.OnPrepareNewSession();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
    }

    public bool CanStartNewSession() => this.m_turnIndex == 0 || this.IsAllReady();

    public bool IsAllReady()
    {
      foreach (Player player in this.Players.Values)
      {
        if (!player.Ready)
          return false;
      }
      return true;
    }

    public void StartLoading()
    {
      if (this.GameState != eGameState.SessionPrepared)
        return;
      this.m_gameState = eGameState.Loading;
      this.m_turnIndex = 0;
      this.SendMissionInfo();
      this.method_10(60);
      this.VaneLoading();
      this.AddAction((IAction) new WaitPlayerLoadingAction((BaseGame) this, 61000));
    }

    public void StartGameMovie()
    {
      if (this.GameState != eGameState.Loading)
        return;
      try
      {
        this.amissionControl_0.OnStartMovie();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
    }

    public void StartGame()
    {
      if (this.GameState != eGameState.Loading)
        return;
      this.StartGameMovie();
      this.m_gameState = eGameState.GameStart;
      this.method_64();
      this.TotalKillCount = 0;
      this.TotalNpcGrade = 0.0;
      this.TotalNpcExperience = 0.0;
      this.TotalHurt = 0;
      this.int_5 = 0;
      this.BossCards = (int[]) null;
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      this.mapPoint_0 = MapMgr.GetPVEMapRandomPos(this.m_map.Info.ID);
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 99);
      pkg.WriteInt(allFightPlayers.Count);
      foreach (Player phy in allFightPlayers)
      {
        if (!phy.IsLiving)
          this.AddLiving((Living) phy);
        phy.Reset();
        Point playerPoint = this.GetPlayerPoint(this.mapPoint_0, phy.Team);
        phy.SetXY(playerPoint);
        this.m_map.AddPhysical((Physics) phy);
        phy.StartFalling(true);
        phy.StartGame();
        pkg.WriteInt(phy.Id);
        pkg.WriteInt(phy.X);
        pkg.WriteInt(phy.Y);
        if (playerPoint.X < 600)
          phy.Direction = 1;
        else
          phy.Direction = -1;
        pkg.WriteInt(phy.Direction);
        pkg.WriteInt(phy.Blood);
        pkg.WriteInt(phy.MaxBlood);
        pkg.WriteInt(phy.Team);
        pkg.WriteInt(phy.Weapon.RefineryLevel);
        pkg.WriteInt(phy.deputyWeaponCount);
        pkg.WriteInt(5);
        pkg.WriteInt(phy.Dander);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(phy.PlayerDetail.FightBuffs.Count);
        foreach (BufferInfo fightBuff in phy.PlayerDetail.FightBuffs)
        {
          pkg.WriteInt(fightBuff.Type);
          pkg.WriteInt(fightBuff.Value);
        }
        pkg.WriteInt(0);
        pkg.WriteBoolean(phy.IsFrost);
        pkg.WriteBoolean(phy.IsHide);
        pkg.WriteBoolean(phy.IsNoHole);
        pkg.WriteBoolean(false);
        pkg.WriteInt(0);
      }
      pkg.WriteInt(0);
      pkg.WriteInt(0);
      pkg.WriteDateTime(DateTime.Now);
      this.SendToAll(pkg);
      this.SendUpdateUiData();
      this.WaitTime(this.PlayerCount * 2500 + 1000);
      this.OnGameStarted();
    }

    public void PrepareNewGame()
    {
      if (this.GameState != eGameState.GameStart)
        return;
      this.m_gameState = eGameState.Playing;
      this.BossCardCount = 0;
      this.method_64();
      this.WaitTime(this.PlayerCount * 1000);
      try
      {
        this.amissionControl_0.OnStartGame();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
    }

    public void NextTurn()
    {
      if (this.GameState != eGameState.Playing)
        return;
      this.ClearWaitTimer();
      this.ClearDiedPhysicals();
      this.CheckBox();
      this.LivingRandSay();
      foreach (Physics physics in this.m_map.GetAllPhysicalSafe())
        physics.PrepareNewTurn();
      List<Box> box = this.CreateBox();
      try
      {
        this.amissionControl_0.OnNewTurnStarted();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
      this.LastTurnLiving = this.m_currentLiving;
      this.m_currentLiving = this.FindNextTurnedLiving();
      if (this.m_currentLiving != null)
      {
        ++this.m_turnIndex;
        this.SendUpdateUiData();
        List<Living> livedLivingsHadTurn = this.GetLivedLivingsHadTurn();
        if (livedLivingsHadTurn.Count > 0 && this.m_currentLiving.Delay >= this.int_6)
        {
          this.MinusDelays(this.int_6);
          foreach (Living living in this.m_livings)
          {
            living.PrepareSelfTurn();
            if (!living.IsFrost)
              living.StartAttacking();
          }
          this.method_55(livedLivingsHadTurn[0], (BaseGame) this, box);
          foreach (Living living in this.m_livings)
          {
            if (living.IsAttacking)
              living.StopAttacking();
          }
          this.int_6 += this.MissionInfo.IncrementDelay;
          this.CheckState(0);
        }
        else if (this.RoomType == eRoomType.ActivityDungeon && this.m_currentLiving is Player)
        {
          TurnedLiving[] nextAllTurnedLiving = this.GetNextAllTurnedLiving();
          this.UpdateWind(this.GetNextWind(), false);
          this.CurrentTurnTotalDamage = 0;
          foreach (TurnedLiving turnedLiving in nextAllTurnedLiving)
          {
            this.MinusDelays(turnedLiving.Delay);
            turnedLiving.PrepareSelfTurn();
            turnedLiving.StartAttacking();
            this.method_64();
            this.method_56((Living) turnedLiving, (BaseGame) this, box);
            this.method_6((Living) turnedLiving, 1);
            this.AddAction((IAction) new WaitLivingAttackingAction(turnedLiving, this.m_turnIndex, (this.m_timeType + 20) * 1000));
          }
        }
        else
        {
          if (this.CanShowBigBox)
          {
            this.ShowBigBox();
            this.CanEnterGate = true;
          }
          this.MinusDelays(this.m_currentLiving.Delay);
          if (this.m_currentLiving is Player)
            this.UpdateWind(this.GetNextWind(), false);
          this.CurrentTurnTotalDamage = 0;
          this.m_currentLiving.PrepareSelfTurn();
          if (this.m_currentLiving.IsLiving && !this.m_currentLiving.IsFrost)
          {
            this.m_currentLiving.StartAttacking();
            this.method_64();
            this.method_55((Living) this.m_currentLiving, (BaseGame) this, box);
            if (this.m_currentLiving.IsAttacking)
              this.AddAction((IAction) new WaitLivingAttackingAction(this.m_currentLiving, this.m_turnIndex, (this.getTurnTime() + 20) * 1000));
          }
        }
      }
      this.OnBeginNewTurn();
      try
      {
        this.amissionControl_0.OnBeginNewTurn();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
    }

    public void LivingRandSay()
    {
      if (this.m_livings == null || this.m_livings.Count == 0)
        return;
      int count = this.m_livings.Count;
      foreach (Living living in this.m_livings)
        living.IsSay = false;
      if (this.TurnIndex % 2 == 0)
        return;
      int num1 = count > 5 ? (count <= 5 || count > 10 ? this.Random.Next(1, 4) : this.Random.Next(1, 3)) : this.Random.Next(0, 2);
      if (num1 <= 0)
        return;
      int num2 = 0;
      while (num2 < num1)
      {
        int index = this.Random.Next(0, count);
        if (!this.m_livings[index].IsSay)
        {
          this.m_livings[index].IsSay = true;
          ++num2;
        }
      }
    }

    public override bool TakeCard(Player player)
    {
      int index1 = 0;
      for (int index2 = 0; index2 < this.Cards.Length; ++index2)
      {
        if (this.Cards[index2] == 0)
        {
          index1 = index2;
          break;
        }
      }
      return this.TakeCard(player, index1);
    }

    public override bool TakeCard(Player player, int index)
    {
      if (player.CanTakeOut == 0 || !player.IsActive || index < 0 || index > this.Cards.Length || player.FinishTakeCard || this.Cards[index] > 0)
        return false;
      int num1 = 0;
      int int_5 = 0;
      int int_6 = 0;
      List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
      int copyId = this.missionInfo_0.Id;
      if (this.Misssions.ContainsKey(this.PreSessionId))
        copyId = this.Misssions[this.PreSessionId].Id;
      int num2 = 30;
      if (this.IsShowLargeCards())
        num2 = 0;
      if (!player.PlayerDetail.MissionEnergyEmpty(num2))
        copyId = 0;
      if (DropInventory.CopyDrop(copyId, 1, ref info))
      {
        if (info != null)
        {
          foreach (SqlDataProvider.Data.ItemInfo cloneItem in info)
          {
            if (cloneItem != null)
            {
              int_5 = cloneItem.TemplateID;
              int_6 = cloneItem.Count;
              player.PlayerDetail.AddTemplate(cloneItem, eBageType.TempBag, cloneItem.Count, eGameView.dungeonTypeGet);
            }
          }
        }
        if (int_5 == 0 && num1 > 0)
        {
          int_5 = -100;
          int_6 = num1;
        }
      }
      if (this.RoomType != eRoomType.Dungeon && this.RoomType != eRoomType.SpecialActivityDungeon)
      {
        player.FinishTakeCard = true;
      }
      else
      {
        --player.CanTakeOut;
        if (player.CanTakeOut == 0)
          player.FinishTakeCard = true;
      }
      this.Cards[index] = 1;
      if (this.Cards.Length >= 21)
        this.method_54(player, index, int_5, int_6);
      else
        this.method_53(player, index, int_5, int_6);
      return true;
    }

    public bool CanGameOver()
    {
      if (this.PlayerCount == 0)
        return true;
      if (this.GetDiedPlayerCount() == this.PlayerCount)
      {
        this.IsWin = false;
        return true;
      }
      try
      {
        return this.amissionControl_0.CanGameOver();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
      return true;
    }

    public void TakeSnow()
    {
      ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(201144);
      if (itemTemplate == null)
        return;
      int count = this.Random.Next(1, 9);
      SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, count, 101);
      fromTemplate.IsBinds = true;
      string msg = "";
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        allFightPlayer.PlayerDetail.AddTemplate(fromTemplate, fromTemplate.Template.BagType, count, eGameView.dungeonTypeGet);
        msg += LanguageMgr.GetTranslation("PVEGame.Msg1", (object) fromTemplate.Template.Name, (object) count);
        allFightPlayer.PlayerDetail.SendMessage(msg);
      }
    }

    public void TakeConsortiaBossAward(bool isWin)
    {
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
        allFightPlayer.PlayerDetail.UpdatePveResult("consortiaboss", allFightPlayer.TotalDameLiving, isWin);
    }

    public void ShowBigBox()
    {
      List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
      DropInventory.CopyDrop(this.missionInfo_0.Id, this.SessionId, ref info);
      List<int> listTemplate = new List<int>();
      if (info != null)
      {
        foreach (SqlDataProvider.Data.ItemInfo itemInfo in info)
          listTemplate.Add(itemInfo.TemplateID);
      }
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (this.method_67(allFightPlayer.PlayerDetail.ProcessLabyrinthAward))
        {
          this.method_42((Living) allFightPlayer, listTemplate);
          allFightPlayer.PlayerDetail.UpdateLabyrinth(this.SessionId, this.missionInfo_0.Id, true);
        }
      }
    }

    private bool method_67(string string_1)
    {
      bool flag = false;
      if (string_1.Length > 0)
      {
        string str1 = string_1;
        char[] chArray = new char[1]{ '-' };
        foreach (string str2 in str1.Split(chArray))
        {
          if (str2 == this.SessionId.ToString())
          {
            flag = true;
            break;
          }
        }
      }
      return flag;
    }

    public void GameOverMovie()
    {
      if (this.GameState != eGameState.Playing)
        return;
      this.m_gameState = eGameState.GameOver;
      this.ClearWaitTimer();
      this.ClearDiedPhysicals();
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      foreach (Player player in allFightPlayers)
      {
        if (this.method_67(player.PlayerDetail.ProcessLabyrinthAward))
          player.PlayerDetail.UpdateLabyrinth(this.SessionId, this.missionInfo_0.Id, false);
      }
      try
      {
        this.amissionControl_0.OnGameOverMovie();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
      bool val;
      if (!(val = this.HasNextSession()))
      {
        GSPacketIn pkg = new GSPacketIn((short) 91);
        pkg.WriteByte((byte) 112);
        pkg.WriteInt(0);
        pkg.WriteBoolean(val);
        pkg.WriteBoolean(false);
        pkg.WriteInt(this.PlayerCount);
        foreach (Player player_0 in allFightPlayers)
        {
          player_0.PlayerDetail.ClearFightBuffOneMatch();
          if (this.IsLabyrinth())
            player_0.PlayerDetail.OutLabyrinth(this.IsWin);
          int gp = this.method_71(player_0);
          int num = this.method_72(player_0);
          this.amissionControl_0.CalculateScoreGrade(player_0.TotalAllScore);
          if (player_0.CurrentIsHitTarget)
            ++player_0.TotalHitTargetCount;
          this.method_73(player_0.TotalHitTargetCount, player_0.TotalShootCount);
          player_0.TotalAllHurt += player_0.TotalHurt;
          player_0.TotalAllCure += player_0.TotalCure;
          player_0.TotalAllHitTargetCount += player_0.TotalHitTargetCount;
          player_0.TotalAllShootCount += player_0.TotalShootCount;
          player_0.GainGP = player_0.PlayerDetail.AddGP(gp);
          player_0.TotalAllExperience += player_0.GainGP;
          player_0.TotalAllScore += num;
          player_0.BossCardCount = this.BossCardCount;
          pkg.WriteInt(player_0.PlayerDetail.PlayerCharacter.ID);
          pkg.WriteInt(player_0.PlayerDetail.PlayerCharacter.Grade);
          pkg.WriteInt(0);
          pkg.WriteInt(player_0.GainGP);
          pkg.WriteBoolean(this.IsWin);
          pkg.WriteInt(this.BossCardCount);
          pkg.WriteInt(player_0.BossCardCount);
          pkg.WriteBoolean(false);
          pkg.WriteBoolean(false);
        }
        if (this.BossCardCount > 0)
        {
          pkg.WriteInt(this.list_5.Count);
          foreach (string str in this.list_5)
            pkg.WriteString(str);
        }
        this.SendToAll(pkg);
        this.OnGameStopped();
        this.OnGameOverred();
      }
      else
      {
        foreach (Physics physics in this.m_map.GetAllPhysicalSafe())
          physics.PrepareNewTurn();
        this.m_currentLiving = this.FindNextTurnedLiving();
        if (this.m_currentLiving != null && this.CanEnterGate)
        {
          ++this.m_turnIndex;
          this.m_currentLiving.PrepareSelfTurn();
          this.method_55((Living) this.m_currentLiving, (BaseGame) this, new List<Box>());
          this.CanEnterGate = false;
          this.CanShowBigBox = false;
          this.EnterNextFloor();
        }
        this.OnBeginNewTurn();
        try
        {
          this.amissionControl_0.OnBeginNewTurn();
        }
        catch (Exception ex)
        {
          PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
        }
      }
    }

    public void EnterNextFloor()
    {
      int foregroundWidth = this.Map.Info.ForegroundWidth;
      Player randomPlayer = this.FindRandomPlayer();
      int num = 150;
      int x1 = randomPlayer.X;
      int y = randomPlayer.Y;
      int x2 = x1 + 150 <= foregroundWidth ? x1 + num : x1 - num;
      Point point = this.m_map.FindYLineNotEmptyPoint(x2, y);
      if (point == Point.Empty)
        point = new Point(x2, this.Map.Bound.Height + 1);
      this.CreatePhysicalObj(point.X, point.Y - 75, "transmitted", "asset.game.transmitted", "out", 1, 1);
    }

    public bool IsLabyrinth() => this.RoomType == eRoomType.Lanbyrinth;

    public void GameOver()
    {
      if (this.GameState != eGameState.Playing)
        return;
      this.m_gameState = eGameState.GameOver;
      this.SendUpdateUiData();
      try
      {
        this.amissionControl_0.OnGameOver();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      this.CurrentTurnTotalDamage = 0;
      this.int_5 = 1;
      bool flag = this.HasNextSession();
      if (!this.IsWin || !flag)
        this.int_5 = 0;
      if (this.IsWin && !flag && !this.method_9())
        this.int_5 = 2;
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 112);
      pkg.WriteInt(this.BossCardCount);
      if (!flag && !this.IsShowLargeCards())
      {
        pkg.WriteBoolean(false);
        pkg.WriteBoolean(false);
      }
      else
      {
        pkg.WriteBoolean(true);
        pkg.WriteString(string.Format("show{0}.jpg", (object) (1 + this.SessionId)));
        pkg.WriteBoolean(true);
      }
      pkg.WriteInt(this.PlayerCount);
      foreach (Player player_0 in allFightPlayers)
      {
        player_0.PlayerDetail.ClearFightBuffOneMatch();
        if (!this.IsWin && this.IsLabyrinth())
          player_0.PlayerDetail.OutLabyrinth(this.IsWin);
        int gp = this.method_71(player_0);
        if (player_0.FightBuffers.ConsortionAddPercentGoldOrGP > 0)
          gp += gp * player_0.FightBuffers.ConsortionAddPercentGoldOrGP / 100;
        int num = this.method_72(player_0);
        this.amissionControl_0.CalculateScoreGrade(player_0.TotalAllScore);
        player_0.CanTakeOut = this.BossCardCount;
        if (player_0.CurrentIsHitTarget)
          ++player_0.TotalHitTargetCount;
        this.method_73(player_0.TotalHitTargetCount, player_0.TotalShootCount);
        player_0.TotalAllHurt += player_0.TotalHurt;
        player_0.TotalAllCure += player_0.TotalCure;
        player_0.TotalAllHitTargetCount += player_0.TotalHitTargetCount;
        player_0.TotalAllShootCount += player_0.TotalShootCount;
        player_0.GainGP = player_0.PlayerDetail.AddGP(gp);
        player_0.TotalAllExperience += player_0.GainGP;
        player_0.TotalAllScore += num;
        player_0.BossCardCount = this.int_5;
        pkg.WriteInt(player_0.PlayerDetail.PlayerCharacter.ID);
        pkg.WriteInt(player_0.PlayerDetail.PlayerCharacter.Grade);
        pkg.WriteInt(0);
        pkg.WriteInt(player_0.GainGP);
        pkg.WriteBoolean(this.IsWin);
        pkg.WriteInt(this.BossCardCount);
        pkg.WriteInt(player_0.BossCardCount);
        pkg.WriteBoolean(false);
        pkg.WriteBoolean(false);
      }
      if (this.BossCardCount > 0)
      {
        pkg.WriteInt(this.list_5.Count);
        foreach (string str in this.list_5)
          pkg.WriteString(str);
      }
      this.SendToAll(pkg);
      StringBuilder stringBuilder1 = new StringBuilder();
      foreach (Player player in allFightPlayers)
      {
        stringBuilder1.Append(player.PlayerDetail.PlayerCharacter.ID).Append(",");
        player.Ready = false;
        player.PlayerDetail.OnMissionOver((AbstractGame) player.Game, this.IsWin, this.MissionInfo.Id, player.TurnNum);
      }
      int _winTeam = this.IsWin ? 1 : 2;
      string _teamA = stringBuilder1.ToString();
      string _teamB = "";
      string _playResult = "";
      if (!this.IsWin)
        this.OnGameStopped();
      StringBuilder stringBuilder2 = new StringBuilder();
      if (this.IsWin && this.IsBossWar != "")
      {
        stringBuilder2.Append(this.IsBossWar).Append(",");
        foreach (Player player in allFightPlayers)
        {
          stringBuilder2.Append("PlayerCharacter ID: ").Append(player.PlayerDetail.PlayerCharacter.ID).Append(",");
          stringBuilder2.Append("Grade: ").Append(player.PlayerDetail.PlayerCharacter.Grade).Append(",");
          stringBuilder2.Append("TurnNum): ").Append(player.TurnNum).Append(",");
          stringBuilder2.Append("Attack: ").Append(player.PlayerDetail.PlayerCharacter.Attack).Append(",");
          stringBuilder2.Append("Defence: ").Append(player.PlayerDetail.PlayerCharacter.Defence).Append(",");
          stringBuilder2.Append("Agility: ").Append(player.PlayerDetail.PlayerCharacter.Agility).Append(",");
          stringBuilder2.Append("Luck: ").Append(player.PlayerDetail.PlayerCharacter.Luck).Append(",");
          stringBuilder2.Append("BaseAttack: ").Append(player.PlayerDetail.BaseAttack).Append(",");
          stringBuilder2.Append("MaxBlood: ").Append(player.MaxBlood).Append(",");
          stringBuilder2.Append("BaseDefence: ").Append(player.PlayerDetail.BaseDefence).Append(",");
          if (player.PlayerDetail.SecondWeapon != null)
          {
            stringBuilder2.Append("SecondWeapon TemplateID: ").Append(player.PlayerDetail.SecondWeapon.TemplateID).Append(",");
            stringBuilder2.Append("SecondWeapon StrengthenLevel: ").Append(player.PlayerDetail.SecondWeapon.StrengthenLevel).Append(".");
          }
        }
      }
      this.BossWarField = stringBuilder2.ToString();
      this.OnGameOverLog(this.RoomId, this.RoomType, this.GameType, 0, this.dateTime_0, DateTime.Now, this.int_4, this.MissionInfo.Id, _teamA, _teamB, _playResult, _winTeam, this.BossWarField);
      this.OnGameOverred();
    }

    public void GameOverArenaAll()
    {
      if (this.GameState == eGameState.Playing)
      {
        this.m_gameState = eGameState.GameOver;
        this.SendUpdateUiData();
        try
        {
          this.amissionControl_0.OnGameOver();
        }
        catch (Exception ex)
        {
          PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
        }
        List<Player> allFightPlayers = this.GetAllFightPlayers();
        GSPacketIn pkg = new GSPacketIn((short) 91);
        pkg.WriteByte((byte) 112);
        pkg.WriteInt(0);
        pkg.WriteBoolean(false);
        pkg.WriteBoolean(false);
        pkg.WriteInt(this.PlayerCount);
        foreach (Player player in allFightPlayers)
        {
          player.PlayerDetail.ClearFightBuffOneMatch();
          player.BossCardCount = 0;
          pkg.WriteInt(player.PlayerDetail.PlayerCharacter.ID);
          pkg.WriteInt(player.PlayerDetail.PlayerCharacter.Grade);
          pkg.WriteInt(0);
          pkg.WriteInt(player.GainGP);
          pkg.WriteBoolean(this.IsWin);
          pkg.WriteInt(0);
          pkg.WriteInt(0);
          pkg.WriteBoolean(false);
          pkg.WriteBoolean(false);
        }
        this.SendToAll(pkg);
      }
      if (this.GameState != eGameState.GameOver)
        return;
      this.m_gameState = eGameState.ALLSessionStopped;
      try
      {
        this.apvegameControl_0.OnGameOverAllSession();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
      List<Player> allFightPlayers1 = this.GetAllFightPlayers();
      GSPacketIn pkg1 = new GSPacketIn((short) 91);
      pkg1.WriteByte((byte) 115);
      pkg1.WriteInt(this.PlayerCount);
      foreach (Player player in allFightPlayers1)
      {
        player.CanTakeOut = 0;
        player.PlayerDetail.OnGameOver((AbstractGame) this, this.IsWin, player.GainGP);
        pkg1.WriteInt(player.PlayerDetail.PlayerCharacter.ID);
        pkg1.WriteInt(0);
        pkg1.WriteInt(player.GainGP);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(0);
        pkg1.WriteInt(player.TotalAllExperience);
        pkg1.WriteInt(0);
        pkg1.WriteBoolean(this.IsWin);
      }
      pkg1.WriteInt(this.list_5.Count);
      foreach (string str in this.list_5)
        pkg1.WriteString(str);
      this.SendToAll(pkg1);
    }

    public bool IsShowLargeCards()
    {
      return this.IsWin && this.Misssions.ContainsKey(1 + this.SessionId) && (this.pveInfo_0.ID == 5 || this.pveInfo_0.ID == 14);
    }

    public bool IsWorldCup() => this.pveInfo_0.ID == 14;

    public bool HasNextSession()
    {
      return this.PlayerCount != 0 && this.IsWin && this.RoomType != eRoomType.ConsortiaBoss && !this.IsShowLargeCards() && this.Misssions.ContainsKey(1 + this.SessionId);
    }

    public void GameOverAllSession()
    {
      if (this.GameState != eGameState.GameOver)
        return;
      this.m_gameState = eGameState.ALLSessionStopped;
      try
      {
        this.apvegameControl_0.OnGameOverAllSession();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) this.GameState, (object) ex);
      }
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 115);
      int num = 1;
      if (!this.IsWin)
      {
        num = 0;
      }
      else
      {
        eRoomType roomType = this.RoomType;
        if (roomType == eRoomType.Dungeon || roomType == eRoomType.SpecialActivityDungeon)
          num = 2;
      }
      pkg.WriteInt(this.PlayerCount);
      foreach (Player player in allFightPlayers)
      {
        player.CanTakeOut = num;
        if (!this.Misssions.ContainsKey(1 + this.SessionId) && this.IsWin && this.RoomType == eRoomType.Dungeon)
          player.PlayerDetail.RemoveMissionEnergy(30);
        player.PlayerDetail.OnGameOver((AbstractGame) this, this.IsWin, player.GainGP);
        pkg.WriteInt(player.PlayerDetail.PlayerCharacter.ID);
        pkg.WriteInt(0);
        pkg.WriteInt(player.GainGP);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(player.TotalAllExperience);
        pkg.WriteInt(0);
        pkg.WriteBoolean(this.IsWin);
      }
      pkg.WriteInt(this.list_5.Count);
      foreach (string str in this.list_5)
        pkg.WriteString(str);
      this.SendToAll(pkg);
      if (this.IsShowLargeCards())
        this.WaitTime(16000);
      else
        this.WaitTime(23000);
      this.CanStopGame();
    }

    public void CanStopGame()
    {
      if (!this.IsWin)
      {
        if (this.GameType != eGameType.Dungeon)
          return;
        this.ClearWaitTimer();
      }
      else
      {
        if (!this.IsShowLargeCards())
          return;
        this.WantTryAgain = 1;
      }
    }

    public void ShowLargeCard()
    {
      if (this.GameState != eGameState.ALLSessionStopped || !this.IsWin)
        return;
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (allFightPlayer.IsActive && allFightPlayer.CanTakeOut > 0)
        {
          allFightPlayer.HasPaymentTakeCard = true;
          int canTakeOut = allFightPlayer.CanTakeOut;
          for (int index = 0; index < canTakeOut; ++index)
            this.TakeCard(allFightPlayer);
        }
      }
      this.method_74();
    }

    public override void Stop()
    {
      if (this.GameState != eGameState.ALLSessionStopped)
        return;
      this.m_gameState = eGameState.Stopped;
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      if (this.IsWin)
      {
        foreach (Player player in allFightPlayers)
        {
          if (player.IsActive && player.CanTakeOut > 0)
          {
            player.HasPaymentTakeCard = true;
            int canTakeOut = player.CanTakeOut;
            for (int index = 0; index < canTakeOut; ++index)
              this.TakeCard(player);
          }
        }
        if (this.RoomType == eRoomType.Dungeon || this.RoomType == eRoomType.SpecialActivityDungeon)
          this.method_74();
        if (this.RoomType == eRoomType.Dungeon)
        {
          foreach (Player player in allFightPlayers)
            player.PlayerDetail.SetPvePermission(this.pveInfo_0.ID, this.eHardLevel_0);
        }
      }
      bool nextMission = this.Misssions.ContainsKey(1 + this.SessionId);
      foreach (Player player in allFightPlayers)
        player.PlayerDetail.ResetRoom(this.IsWin, nextMission);
      lock (this.m_players)
        this.m_players.Clear();
      this.OnGameStopped();
    }

    protected override void Dispose(bool disposing)
    {
      base.Dispose(disposing);
      foreach (Physics living in this.m_livings)
        living.Dispose();
      try
      {
        this.amissionControl_0.Dispose();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script m_missionAI.Dispose() error:{1}", (object) ex);
      }
      try
      {
        this.apvegameControl_0.Dispose();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script m_gameAI.Dispose() error:{1}", (object) ex);
      }
    }

    public void DoOther()
    {
      try
      {
        this.amissionControl_0.DoOther();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script m_gameAI.DoOther() error:{1}", (object) ex);
      }
    }

    internal void method_68()
    {
      try
      {
        this.amissionControl_0.OnShooted();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script m_gameAI.OnShooted() error:{1}", (object) ex);
      }
    }

    internal void method_69()
    {
      try
      {
        this.amissionControl_0.OnMoving();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script m_gameAI.OnMoving() error:{1}", (object) ex);
      }
    }

    internal void method_70()
    {
      try
      {
        this.amissionControl_0.OnTakeDamage();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script m_gameAI.OnTakeDamage() error:{1}", (object) ex);
      }
    }

    private int method_71(Player player_0)
    {
      if (this.TotalKillCount == 0)
        return 1;
      double num1 = Math.Abs((double) player_0.Grade - this.TotalNpcGrade / (double) this.TotalKillCount);
      if (num1 >= 7.0)
        return 1;
      double num2 = 0.0;
      if (this.TotalKillCount > 0)
        num2 += (double) player_0.TotalKill / (double) this.TotalKillCount * 0.4;
      if (this.TotalHurt > 0)
        num2 += (double) player_0.TotalHurt / (double) this.TotalHurt * 0.4;
      if (player_0.IsLiving)
        num2 += 0.4;
      double num3 = 1.0;
      if (num1 >= 3.0 && num1 <= 4.0)
        num3 = 0.7;
      else if (num1 >= 5.0 && num1 <= 6.0)
        num3 = 0.4;
      double num4 = (0.9 + (double) (this.int_4 - 1) * 0.4) / (double) this.PlayerCount;
      double num5 = this.TotalNpcExperience * num2 * num3 * num4;
      return num5 == 0.0 ? 1 : (int) num5;
    }

    private int method_72(Player player_0)
    {
      int num = (200 - this.TurnIndex) * 5 + player_0.TotalKill * 5 + (int) ((double) player_0.Blood / (double) player_0.MaxBlood) * 10;
      if (!this.IsWin)
        num -= 400;
      return num;
    }

    private int method_73(int int_7, int int_8)
    {
      double num = 0.0;
      if (int_8 > 0)
        num = (double) int_7 / (double) int_8;
      return (int) (num * 100.0);
    }

    public override void CheckState(int delay)
    {
      this.AddAction((IAction) new CheckPVEGameStateAction(delay));
    }

    public bool TakeBossCard(Player player)
    {
      int index1 = 0;
      for (int index2 = 0; index2 < this.BossCards.Length; ++index2)
      {
        if (this.Cards[index2] == 0)
        {
          index1 = index2;
          break;
        }
      }
      return this.TakeCard(player, index1);
    }

    public bool TakeBossCard(Player player, int index)
    {
      if (!player.IsActive || player.BossCardCount <= 0 || index < 0 || index > this.BossCards.Length || this.BossCards[index] > 0)
        return false;
      List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
      int int_5 = 0;
      int int_6 = 0;
      int num = 0;
      DropInventory.BossDrop(int.Parse(this.IsBossWar), ref info);
      if (info != null)
      {
        foreach (SqlDataProvider.Data.ItemInfo cloneItem in info)
        {
          if (cloneItem != null)
          {
            player.PlayerDetail.AddTemplate(cloneItem, eBageType.TempBag, cloneItem.Count, eGameView.dungeonTypeGet);
            int_5 = cloneItem.TemplateID;
            int_6 = cloneItem.Count;
          }
        }
      }
      if (int_5 == 0 && num > 0)
      {
        int_5 = -100;
        int_6 = num;
      }
      --player.BossCardCount;
      this.BossCards[index] = 1;
      if (this.Cards.Length >= 21)
        this.method_54(player, index, int_5, int_6);
      else
        this.method_53(player, index, int_5, int_6);
      return true;
    }

    public void SendMissionInfo()
    {
      if (this.missionInfo_0 == null)
        return;
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 113);
      pkg.WriteInt(this.missionInfo_0.Id);
      pkg.WriteString(this.missionInfo_0.Name);
      pkg.WriteString(this.missionInfo_0.Success);
      pkg.WriteString(this.missionInfo_0.Failure);
      pkg.WriteString(this.missionInfo_0.Description);
      pkg.WriteString(this.missionInfo_0.Title);
      pkg.WriteInt(this.TotalMissionCount);
      pkg.WriteInt(this.SessionId);
      pkg.WriteInt(this.TotalTurn);
      pkg.WriteInt(this.TotalCount);
      pkg.WriteInt(this.Param1);
      pkg.WriteInt(this.Param2);
      pkg.WriteInt(this.WantTryAgain);
      pkg.WriteString(this.Pic);
      this.SendToAll(pkg);
    }

    public void SendUpdateUiData()
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 104);
      int val = 0;
      try
      {
        val = this.amissionControl_0.UpdateUIData();
      }
      catch (Exception ex)
      {
        PVEGame.ilog_0.ErrorFormat("game ai script {0} error:{1}", (object) string.Format("m_missionAI.UpdateUIData()"), (object) ex);
      }
      pkg.WriteInt(this.TurnIndex);
      pkg.WriteInt(val);
      pkg.WriteInt(this.Param3);
      pkg.WriteInt(this.Param4);
      this.SendToAll(pkg);
    }

    internal void method_74()
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 89);
      List<int> intList = new List<int>();
      for (int index = 0; index < this.Cards.Length; ++index)
      {
        if (this.Cards[index] == 0)
          intList.Add(index);
      }
      int val1 = 0;
      int val2 = 0;
      pkg.WriteInt(intList.Count);
      int id = this.missionInfo_0.Id;
      if (this.Misssions.ContainsKey(this.PreSessionId))
        id = this.Misssions[this.PreSessionId].Id;
      foreach (int val3 in intList)
      {
        List<SqlDataProvider.Data.ItemInfo> itemInfoList = DropInventory.CopySystemDrop(id, intList.Count);
        if (itemInfoList != null)
        {
          foreach (SqlDataProvider.Data.ItemInfo itemInfo in itemInfoList)
          {
            val1 = itemInfo.TemplateID;
            val2 = itemInfo.Count;
          }
        }
        pkg.WriteByte((byte) val3);
        pkg.WriteInt(val1);
        pkg.WriteInt(val2);
      }
      this.SendToAll(pkg);
    }

    public void SendGameObjectFocus(int type, string name, int delay, int finishTime)
    {
      foreach (Physics physics in (Physics[]) this.FindPhysicalObjByName(name))
        this.AddAction((IAction) new FocusAction(physics, type, delay, finishTime));
    }

    private void method_75(PVEGame pvegame_0, IGamePlayer igamePlayer_0)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 121);
      pkg.WriteInt(pvegame_0.Map.Info.ID);
      pkg.WriteInt((int) (byte) pvegame_0.RoomType);
      pkg.WriteInt((int) (byte) pvegame_0.GameType);
      pkg.WriteInt(pvegame_0.TimeType);
      List<Player> allFightPlayers = pvegame_0.GetAllFightPlayers();
      pkg.WriteInt(allFightPlayers.Count);
      foreach (Player player in allFightPlayers)
      {
        IGamePlayer playerDetail = player.PlayerDetail;
        pkg.WriteInt(playerDetail.PlayerCharacter.ID);
        pkg.WriteString(playerDetail.PlayerCharacter.NickName);
        pkg.WriteBoolean(false);
        pkg.WriteByte(playerDetail.PlayerCharacter.typeVIP);
        pkg.WriteInt(playerDetail.PlayerCharacter.VIPLevel);
        pkg.WriteBoolean(playerDetail.PlayerCharacter.Sex);
        pkg.WriteInt(playerDetail.PlayerCharacter.Hide);
        pkg.WriteString(playerDetail.PlayerCharacter.Style);
        pkg.WriteString(playerDetail.PlayerCharacter.Colors);
        pkg.WriteString(playerDetail.PlayerCharacter.Skin);
        pkg.WriteInt(playerDetail.PlayerCharacter.Grade);
        pkg.WriteInt(playerDetail.PlayerCharacter.Repute);
        if (playerDetail.MainWeapon == null)
          pkg.WriteInt(0);
        else if (playerDetail.MainWeapon.IsGold)
          pkg.WriteInt(playerDetail.MainWeapon.GoldEquip.TemplateID);
        else
          pkg.WriteInt(playerDetail.MainWeapon.TemplateID);
        pkg.WriteInt(playerDetail.MainWeapon.RefineryLevel);
        pkg.WriteString(playerDetail.MainWeapon.Template.Name);
        pkg.WriteDateTime(DateTime.MinValue);
        if (playerDetail.SecondWeapon == null)
          pkg.WriteInt(0);
        else
          pkg.WriteInt(playerDetail.SecondWeapon.TemplateID);
        pkg.WriteInt(playerDetail.PlayerCharacter.ConsortiaID);
        pkg.WriteString(playerDetail.PlayerCharacter.ConsortiaName);
        pkg.WriteInt(playerDetail.PlayerCharacter.badgeID);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteBoolean(false);
        pkg.WriteInt(0);
        pkg.WriteInt(player.Team);
        pkg.WriteInt(player.Id);
        pkg.WriteInt(player.MaxBlood);
        pkg.WriteBoolean(player.Ready);
      }
      int sessionId = pvegame_0.SessionId;
      MissionInfo misssion = pvegame_0.Misssions[sessionId];
      pkg.WriteString(misssion.Name);
      pkg.WriteString(string.Format("show{0}.jpg", (object) sessionId));
      pkg.WriteString(misssion.Success);
      pkg.WriteString(misssion.Failure);
      pkg.WriteString(misssion.Description);
      pkg.WriteInt(pvegame_0.TotalMissionCount);
      pkg.WriteInt(sessionId);
      igamePlayer_0.SendTCP(pkg);
    }

    public void SendPlayerInfoInGame(PVEGame game, IGamePlayer gp, Player p)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.Parameter2 = this.LifeTime;
      pkg.WriteByte((byte) 120);
      pkg.WriteInt(gp.ZoneId);
      pkg.WriteInt(gp.PlayerCharacter.ID);
      pkg.WriteInt(p.Team);
      pkg.WriteInt(p.Id);
      pkg.WriteInt(p.MaxBlood);
      pkg.WriteBoolean(p.Ready);
      game.SendToAll(pkg);
    }

    public void SendPlaySound(string playStr)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 63);
      pkg.WriteString(playStr);
      this.SendToAll(pkg);
    }

    public void SendLoadResource(List<LoadingFileInfo> loadingFileInfos)
    {
      if (loadingFileInfos == null || loadingFileInfos.Count <= 0)
        return;
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 67);
      pkg.WriteInt(loadingFileInfos.Count);
      foreach (LoadingFileInfo loadingFileInfo in loadingFileInfos)
      {
        pkg.WriteInt(loadingFileInfo.Type);
        pkg.WriteString(loadingFileInfo.Path);
        pkg.WriteString(loadingFileInfo.ClassName);
      }
      this.SendToAll(pkg);
    }

    public override void MinusDelays(int lowestDelay)
    {
      this.int_6 -= lowestDelay;
      base.MinusDelays(lowestDelay);
    }

    public void Print(string str) => Console.WriteLine(str);
  }
}
