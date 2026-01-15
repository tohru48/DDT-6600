// Decompiled with JetBrains decompiler
// Type: Game.Logic.PVPGame
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
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
  public class PVPGame : BaseGame
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private List<Player> list_5;
    private float float_0;
    private List<Player> list_6;
    private float float_1;
    private int int_4;
    private string string_0;
    private string string_1;
    private DateTime dateTime_0;
    private int int_5;

    public Player CurrentPlayer => this.m_currentLiving as Player;

    public PVPGame(
      int id,
      int roomId,
      List<IGamePlayer> red,
      List<IGamePlayer> blue,
      Map map,
      eRoomType roomType,
      eGameType gameType,
      int timeType)
      : base(id, roomId, map, roomType, gameType, timeType)
    {
      this.list_5 = new List<Player>();
      this.list_6 = new List<Player>();
      StringBuilder stringBuilder1 = new StringBuilder();
      this.float_0 = 0.0f;
      foreach (IGamePlayer gamePlayer in red)
      {
        Player fp = new Player(gamePlayer, this.PhysicalId++, (BaseGame) this, 1, gamePlayer.PlayerCharacter.hp);
        stringBuilder1.Append(gamePlayer.PlayerCharacter.ID).Append(",");
        fp.Reset();
        fp.Direction = this.m_random.Next(0, 1) == 0 ? 1 : -1;
        this.AddPlayer(gamePlayer, fp);
        this.list_5.Add(fp);
        this.float_0 += (float) gamePlayer.PlayerCharacter.Grade;
      }
      this.float_0 /= (float) this.list_5.Count;
      this.string_0 = stringBuilder1.ToString();
      StringBuilder stringBuilder2 = new StringBuilder();
      this.float_1 = 0.0f;
      foreach (IGamePlayer gamePlayer in blue)
      {
        Player fp = new Player(gamePlayer, this.PhysicalId++, (BaseGame) this, 2, gamePlayer.PlayerCharacter.hp);
        stringBuilder2.Append(gamePlayer.PlayerCharacter.ID).Append(",");
        fp.Reset();
        fp.Direction = this.m_random.Next(0, 1) == 0 ? 1 : -1;
        this.AddPlayer(gamePlayer, fp);
        this.list_6.Add(fp);
        this.float_1 += (float) gamePlayer.PlayerCharacter.Grade;
      }
      this.float_1 /= (float) blue.Count;
      this.string_1 = stringBuilder2.ToString();
      this.int_4 = this.list_5.Count + this.list_6.Count;
      this.dateTime_0 = DateTime.Now;
      this.int_5 = red.Count;
    }

    public void Prepare()
    {
      if (this.GameState != eGameState.Inited)
        return;
      this.method_1();
      this.m_gameState = eGameState.Prepared;
      this.CheckState(0);
    }

    public void StartLoading()
    {
      if (this.GameState != eGameState.Prepared)
        return;
      if (this.RoomType == eRoomType.FightFootballTime)
        this.LoadFightFootballResources();
      this.ClearWaitTimer();
      this.method_10(60);
      this.VaneLoading();
      if (this.RoomType == eRoomType.Encounter)
      {
        foreach (Physics allFightPlayer in this.GetAllFightPlayers())
          this.method_3(allFightPlayer.Id);
      }
      this.AddAction((IAction) new WaitPlayerLoadingAction((BaseGame) this, 61000));
      this.m_gameState = eGameState.Loading;
    }

    public void LoadFightFootballResources()
    {
      int[] numArray = new int[5]
      {
        10008,
        10005,
        10006,
        10009,
        10007
      };
      foreach (int id in numArray)
      {
        NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(id);
        if (npcInfoById == null)
          PVPGame.ilog_0.Error((object) "LoadResources npcInfo resoure is not exits");
        else
          this.AddLoadingFile(2, npcInfoById.ResourcesPath, npcInfoById.ModelID);
      }
      this.AddLoadingFile(1, "bombs/24.swf", "tank.resource.bombs.Bomb24");
    }

    public void StartGame()
    {
      if (this.GameState != eGameState.Loading)
        return;
      this.m_gameState = eGameState.Playing;
      this.ClearWaitTimer();
      this.method_64();
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      MapPoint mapRandomPos = MapMgr.GetMapRandomPos(this.m_map.Info.ID);
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 99);
      pkg.WriteInt(allFightPlayers.Count);
      foreach (Player phy in allFightPlayers)
      {
        phy.Reset();
        Point playerPoint = this.GetPlayerPoint(mapRandomPos, phy.Team);
        phy.SetXY(playerPoint);
        this.m_map.AddPhysical((Physics) phy);
        phy.StartFalling(true);
        phy.StartGame();
        pkg.WriteInt(phy.Id);
        pkg.WriteInt(phy.X);
        pkg.WriteInt(phy.Y);
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
      pkg.WriteDateTime(this.dateTime_0);
      this.SendToAll(pkg);
      this.WaitTime(allFightPlayers.Count * 1000);
      this.OnGameStarted();
    }

    public void CreateNpc(int npcId, int x, int y, int type, int direction)
    {
      SimpleNpc simpleNpc = new SimpleNpc(this.PhysicalId++, (BaseGame) this, NPCInfoMgr.GetNpcInfoById(npcId), type, direction);
      simpleNpc.Reset();
      simpleNpc.SetXY(x, y);
      this.AddLiving((Living) simpleNpc);
      simpleNpc.StartMoving();
    }

    public void CreateNpc()
    {
      int[] array1 = new int[5]
      {
        10008,
        10005,
        10006,
        10009,
        10007
      };
      int[] array2 = new int[3]{ 350, 500, 680 };
      this.Shuffer<int>(array2);
      this.Shuffer<int>(array1);
      this.ClearAllNpc();
      int x = array2[this.Random.Next(array2.Length)];
      for (int index = 0; index < array1.Length; ++index)
      {
        this.CreateNpc(array1[index], x, 259, 1, -1);
        x += 210;
      }
    }

    public void NextTurn()
    {
      if (this.GameState != eGameState.Playing)
        return;
      this.ClearWaitTimer();
      this.ClearDiedPhysicals();
      this.CheckBox();
      ++this.m_turnIndex;
      List<Box> box = this.CreateBox();
      foreach (Physics physics in this.m_map.GetAllPhysicalSafe())
        physics.PrepareNewTurn();
      this.LastTurnLiving = this.m_currentLiving;
      if (this.RoomType == eRoomType.FightFootballTime)
      {
        this.CreateNpc();
        this.m_currentLiving = this.FindNextTurnedFightFootball();
      }
      else
        this.m_currentLiving = this.FindNextTurnedLiving();
      if (this.m_currentLiving.VaneOpen)
        this.UpdateWind(this.GetNextWind(), false);
      this.MinusDelays(this.m_currentLiving.Delay);
      this.m_currentLiving.PrepareSelfTurn();
      if (!this.CurrentLiving.IsFrost && this.m_currentLiving.IsLiving)
      {
        this.m_currentLiving.StartAttacking();
        this.method_55((Living) this.m_currentLiving, (BaseGame) this, box);
        if (this.m_currentLiving.IsAttacking)
          this.AddAction((IAction) new WaitLivingAttackingAction(this.m_currentLiving, this.m_turnIndex, (this.getTurnTime() + 20) * 1000));
        if (this.m_currentLiving is Player && this.EntertainmentMode())
          (this.m_currentLiving as Player).PlayerDetail.CreateRandomEnterModeItem();
      }
      this.OnBeginNewTurn();
    }

    public bool EntertainmentMode()
    {
      return this.RoomType == eRoomType.Entertainment || this.RoomType == eRoomType.EntertainmentPK;
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
      --player.CanTakeOut;
      int int_5 = 0;
      int int_6 = 0;
      List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
      if (DropInventory.CardDrop(this.RoomType, ref info) && info != null)
      {
        foreach (SqlDataProvider.Data.ItemInfo cloneItem in info)
        {
          int_5 = cloneItem.TemplateID;
          int_6 = cloneItem.Count;
          player.PlayerDetail.AddTemplate(cloneItem, eBageType.TempBag, cloneItem.Count, eGameView.BatleTypeGet);
        }
      }
      player.FinishTakeCard = true;
      this.Cards[index] = 1;
      if (this.Cards.Length >= 21)
        this.method_54(player, index, int_5, int_6);
      else
        this.method_53(player, index, int_5, int_6);
      return true;
    }

    private int method_65(Player player_0, int int_6, ref int int_7)
    {
      int num1 = 1;
      if (this.m_roomType == eRoomType.Match || this.RoomType == eRoomType.BattleRoom)
      {
        float num2 = player_0.Team == 1 ? this.float_1 : this.float_0;
        float num3 = player_0.Team == 1 ? (float) this.list_6.Count : (float) this.list_5.Count;
        double num4 = (double) Math.Abs(num2 - (float) player_0.PlayerDetail.PlayerCharacter.Grade);
        if (player_0.TotalHurt == 0)
        {
          if ((double) num2 - (double) this.float_1 < 5.0 && (double) num2 - (double) this.float_0 < 5.0 || this.TotalHurt <= 0)
            return 1;
          this.method_59(player_0.PlayerDetail, LanguageMgr.GetTranslation("GetGPreward"), (string) null, 2);
          int_7 = 200;
          return 201;
        }
        float num5 = player_0.Team == int_6 ? 2f : 0.0f;
        double num6 = (double) (GameProperties.GPRate / 10);
        player_0.TotalShootCount = player_0.TotalShootCount == 0 ? 1 : player_0.TotalShootCount;
        if (player_0.TotalShootCount < player_0.TotalHitTargetCount)
          player_0.TotalShootCount = player_0.TotalHitTargetCount;
        int num7 = player_0.Team == 1 ? (int) ((double) this.list_6.Count * (double) this.float_1 * 300.0) : (int) ((double) this.float_0 * (double) this.list_5.Count * 300.0);
        int num8 = player_0.TotalHurt > num7 ? num7 : player_0.TotalHurt;
        int gp = (int) Math.Ceiling(((double) num5 + (double) num8 * (0.019 + num6) + (double) player_0.TotalKill * 0.5 + (double) (player_0.TotalHitTargetCount / player_0.TotalShootCount * 2)) * (double) num2 * (0.9 + ((double) num3 - 1.0) * 0.3));
        if (((double) num2 - (double) this.float_1 >= 5.0 || (double) num2 - (double) this.float_0 >= 5.0) && this.TotalHurt > 0)
        {
          this.method_59(player_0.PlayerDetail, LanguageMgr.GetTranslation("GetGPreward"), (string) null, 2);
          int_7 = 200;
          gp += 200;
        }
        num1 = this.GainCoupleGP(player_0, gp);
        if (num1 > 100000)
          num1 = 100000;
      }
      if (this.m_roomType == eRoomType.FightFootballTime)
      {
        int num9 = 0;
        foreach (int num10 in player_0.ScoreArr)
          num9 += num10;
        num1 = num9 * 50;
      }
      return num1 >= 1 ? num1 : 1;
    }

    public int GainCoupleGP(Player player, int gp)
    {
      foreach (Player player1 in this.GetSameTeamPlayer(player))
      {
        if (player1.PlayerDetail.PlayerCharacter.SpouseID == player.PlayerDetail.PlayerCharacter.SpouseID)
          return (int) ((double) gp * 1.2);
      }
      return gp;
    }

    public Player[] GetSameTeamPlayer(Player player)
    {
      List<Player> playerList = new List<Player>();
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (allFightPlayer != player && allFightPlayer.Team == player.Team)
          playerList.Add(allFightPlayer);
      }
      return playerList.ToArray();
    }

    public bool CheckIp(List<Player> players, Player self)
    {
      string str = self.PlayerDetail.TcpEndPoint();
      foreach (Player player in players)
      {
        if (player.Id != self.Id && player.PlayerDetail.TcpEndPoint() == str)
          return true;
      }
      return false;
    }

    public int GetDragonBoatScrore(List<Player> players, int winTeam)
    {
      int num = 0;
      foreach (Living player in players)
      {
        if (player.Team == winTeam)
          ++num;
      }
      switch (num)
      {
        case 2:
          return 2;
        case 3:
          return 3;
        case 4:
          return 4;
        default:
          return 1;
      }
    }

    public void GameOver()
    {
      if (this.GameState != eGameState.Playing)
        return;
      this.m_gameState = eGameState.GameOver;
      this.ClearWaitTimer();
      this.CurrentTurnTotalDamage = 0;
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      int num1 = -1;
      foreach (Player player in allFightPlayers)
      {
        if (player.IsLiving)
        {
          num1 = player.Team;
          break;
        }
      }
      if (num1 == -1 && this.CurrentPlayer != null)
        num1 = this.CurrentPlayer.Team;
      int val = this.method_66(allFightPlayers, num1);
      if (this.RoomType == eRoomType.Match && this.GameType == eGameType.Guild)
      {
        int num2 = 10 + allFightPlayers.Count / 2;
        int num3 = (int) Math.Round((double) (allFightPlayers.Count / 2) * 0.5) - 10;
      }
      int num4 = 0;
      int num5 = 0;
      foreach (Player player in allFightPlayers)
      {
        if (player.TotalHurt > 0)
        {
          if (player.Team == 1)
            num5 = 1;
          else
            num4 = 1;
        }
      }
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 100);
      pkg.WriteInt(0);
      pkg.WriteInt(this.PlayerCount);
      foreach (Player player in allFightPlayers)
      {
        float num6 = player.Team == 1 ? this.float_1 : this.float_0;
        if (player.Team != 1)
        {
          int count1 = this.list_5.Count;
        }
        else
        {
          int count2 = this.list_6.Count;
        }
        float num7 = Math.Abs(num6 - (float) player.PlayerDetail.PlayerCharacter.Grade);
        int team = player.Team;
        int num8 = 0;
        int int_7 = 0;
        if (player.TotalShootCount != 0)
          ;
        if (this.RoomType == eRoomType.BattleRoom || this.m_roomType == eRoomType.Match || (double) num7 < 5.0)
          num8 = this.method_65(player, num1, ref int_7);
        int num9 = num8 == 0 ? 1 : num8;
        string str1 = ". ";
        string str2 = "";
        player.CanTakeOut = player.Team == 1 ? num5 : num4;
        val += player.GainOffer;
        bool flag1 = this.RoomType != eRoomType.FightFootballTime ? player.Team == num1 : player.Team == 1 && this.blueScore > this.redScore || player.Team == 2 && this.blueScore < this.redScore;
        if (this.RoomType == eRoomType.Match || this.RoomType == eRoomType.BattleRoom)
        {
          int num10 = this.Random.Next(int.Parse(GameProperties.MoneyRateLost.Split('|')[0]), int.Parse(GameProperties.MoneyRateLost.Split('|')[1]));
          int num11 = this.Random.Next(int.Parse(GameProperties.DDTMoneyRateLost.Split('|')[0]), int.Parse(GameProperties.DDTMoneyRateLost.Split('|')[1]));
          int num12 = GameProperties.LeagueMoneyLose;
          int num13 = this.Random.Next(int.Parse(GameProperties.ExpRateLost.Split('|')[0]), int.Parse(GameProperties.ExpRateLost.Split('|')[1]));
          if (flag1)
          {
            num12 = GameProperties.LeagueMoneyWin;
            num10 = this.Random.Next(int.Parse(GameProperties.MoneyRateWin.Split('|')[0]), int.Parse(GameProperties.MoneyRateWin.Split('|')[1]));
            num11 = this.Random.Next(int.Parse(GameProperties.DDTMoneyRateWin.Split('|')[0]), int.Parse(GameProperties.DDTMoneyRateWin.Split('|')[1]));
            num13 = this.Random.Next(int.Parse(GameProperties.ExpRateWin.Split('|')[0]), int.Parse(GameProperties.ExpRateWin.Split('|')[1]));
          }
          if (allFightPlayers.Count > 2)
          {
            if (GameProperties.DoubleMoneyActive)
              num10 *= GameProperties.DoubleMoneyRate;
            if (GameProperties.DoubleDDTMoneyActive)
              num11 *= GameProperties.DoubleDDTMoneyRate;
            if (GameProperties.DoubleExpActive)
              num13 *= GameProperties.DoubleExpRate;
          }
          int num14 = int.Parse(GameProperties.DisibleBonusMoneyHour.Split('|')[0]);
          int num15 = int.Parse(GameProperties.DisibleBonusMoneyHour.Split('|')[1]);
          DateTime now = DateTime.Now;
          int num16;
          if (now.Hour >= num14)
          {
            now = DateTime.Now;
            if (now.Hour <= num15)
            {
              num16 = 0;
              goto label_46;
            }
          }
          now = DateTime.Now;
          if (now.Hour <= num14)
          {
            now = DateTime.Now;
            num16 = now.Hour < num15 ? 1 : 0;
          }
          else
            num16 = 1;
label_46:
          if (num16 == 0)
          {
            if (num14 < num15)
              player.PlayerDetail.SendMessage(LanguageMgr.GetTranslation("PVPGame.SendGameOVer.DisibleBonusMoneyHour", (object) num14, (object) num15));
            else
              player.PlayerDetail.SendMessage(LanguageMgr.GetTranslation("PVPGame.SendGameOVer.DisibleBonusMoneyHour", (object) num15, (object) num14));
          }
          else if (this.CheckIp(allFightPlayers, player))
          {
            player.PlayerDetail.SendMessage(LanguageMgr.GetTranslation("PVPGame.SendGameOVer.SameIp"));
          }
          else
          {
            string[] strArray = GameProperties.GoldHour.Split(',');
            for (int index = 0; index < strArray.Length; ++index)
            {
              if (index != 1)
              {
                int num17 = int.Parse(strArray[index].Split('|')[0]);
                int num18 = int.Parse(strArray[index].Split('|')[1]);
                now = DateTime.Now;
                int num19;
                if (now.Hour >= num17)
                {
                  now = DateTime.Now;
                  if (now.Hour <= num18)
                  {
                    num19 = 0;
                    goto label_60;
                  }
                }
                now = DateTime.Now;
                if (now.Hour <= num17)
                {
                  now = DateTime.Now;
                  num19 = now.Hour < num18 ? 1 : 0;
                }
                else
                  num19 = 1;
label_60:
                if (num19 == 0)
                {
                  num10 += int.Parse(strArray[1]);
                  str1 += LanguageMgr.GetTranslation("PVPGame.SendGameOVer.GoldHour", (object) int.Parse(strArray[1]));
                }
              }
            }
            player.PlayerDetail.AddMoney(num10);
            player.PlayerDetail.AddActiveMoney(num10);
            str2 = LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg1", (object) num10);
            if (GameProperties.DDTMoneyActive)
            {
              player.PlayerDetail.AddGiftToken(num10);
              str2 += LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg8", (object) num11);
            }
            num9 += num13;
            str1 += LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Exp", (object) num13);
            int num20 = player.PlayerDetail.DragonBoatAddExpPlus();
            if (num20 > 0)
            {
              num9 *= num20;
              str1 += LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg9", (object) num20);
            }
            int bonusBaseScore = GameProperties.BonusBaseScore;
            if (flag1)
              bonusBaseScore *= 2;
            if (player.PlayerDetail.DragonBoatOpen() && player.PlayerDetail.IsCrossZone)
            {
              int num21 = bonusBaseScore * this.GetDragonBoatScrore(allFightPlayers, num1);
              str1 += LanguageMgr.GetTranslation("PVPGame.SendGameOVer.DragonBoatOpen", (object) num21);
              player.PlayerDetail.AddBoatScore(num21);
            }
            int restCount = player.PlayerDetail.MatchInfo.restCount;
            bool flag2 = player.PlayerDetail.PlayerCharacter.Grade >= 20;
            if (this.PlayerCount == 4 && flag2 && restCount > 0)
            {
              string translation = LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg6", (object) num12);
              if (!flag1)
                translation = LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg7", (object) num12);
              player.PlayerDetail.SendMessage(translation);
              player.PlayerDetail.AddLeagueMoney(num12);
              player.PlayerDetail.UpdateRestCount();
            }
          }
        }
        player.PlayerDetail.SendHideMessage(str2 + str1);
        player.PlayerDetail.AddPrestige(flag1, this.RoomType);
        if (player.FightBuffers.ConsortionAddPercentGoldOrGP > 0)
          num9 += num9 * player.FightBuffers.ConsortionAddPercentGoldOrGP / 100;
        if (player.FightBuffers.ConsortionAddOfferRate > 0)
          val *= player.FightBuffers.ConsortionAddOfferRate;
        player.PlayerDetail.FootballTakeOut(flag1);
        player.GainGP = player.PlayerDetail.AddGP(num9);
        player.GainOffer = player.PlayerDetail.AddOffer(val);
        pkg.WriteInt(player.Id);
        pkg.WriteBoolean(flag1);
        pkg.WriteInt(player.Grade);
        pkg.WriteInt(player.PlayerDetail.PlayerCharacter.GP);
        pkg.WriteInt(0);
        pkg.WriteInt(num9);
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
        pkg.WriteInt(0);
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
        pkg.WriteInt(player.GainOffer);
        pkg.WriteInt(0);
        pkg.WriteInt(player.CanTakeOut);
        player.PlayerDetail.OnGameOver((AbstractGame) this, player.Team == num1, player.GainGP);
      }
      pkg.WriteInt(val);
      pkg.WriteInt(0);
      pkg.WriteInt(0);
      this.SendToAll(pkg);
      this.WaitTime(15000);
      this.OnGameOverred();
    }

    public override void Stop()
    {
      if (this.GameState != eGameState.GameOver)
        return;
      this.m_gameState = eGameState.Stopped;
      foreach (Player allFightPlayer in this.GetAllFightPlayers())
      {
        if (!allFightPlayer.PlayerDetail.PlayerCharacter.IsAutoBot && allFightPlayer.IsActive && !allFightPlayer.FinishTakeCard && allFightPlayer.CanTakeOut > 0 && this.RoomType != eRoomType.FightFootballTime)
          this.TakeCard(allFightPlayer);
      }
      lock (this.m_players)
        this.m_players.Clear();
      base.Stop();
    }

    public void GameOverArenaMode()
    {
      if (this.GameState != eGameState.Playing)
        return;
      this.m_gameState = eGameState.Stopped;
      this.ClearWaitTimer();
      this.CurrentTurnTotalDamage = 0;
      List<Player> allFightPlayers = this.GetAllFightPlayers();
      int num1 = -1;
      foreach (Player player in allFightPlayers)
      {
        if (player.IsLiving)
        {
          num1 = player.Team;
          break;
        }
      }
      if (num1 == -1 && this.CurrentPlayer != null)
        num1 = this.CurrentPlayer.Team;
      int num2 = 0;
      int num3 = 0;
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 100);
      pkg.WriteInt(0);
      pkg.WriteInt(this.PlayerCount);
      foreach (Player player in allFightPlayers)
      {
        player.CanTakeOut = player.Team == 1 ? num3 : num2;
        bool flag = player.Team == num1;
        if (this.EntertainmentMode())
        {
          int num4 = 0;
          switch (this.int_5)
          {
            case 1:
              num4 = !flag ? 4 : 10;
              break;
            case 2:
              num4 = !flag ? 6 : 15;
              break;
            case 3:
              num4 = !flag ? 10 : 25;
              break;
            case 4:
              num4 = !flag ? 16 : 40;
              break;
          }
          if (num4 > 0)
          {
            player.PlayerDetail.AddEnterModePoint(num4);
            player.PlayerDetail.SendMessage(LanguageMgr.GetTranslation("GameServer.TakeEntertamainPoint.Msg", (object) num4));
          }
          if (this.RoomType == eRoomType.EntertainmentPK && flag)
          {
            player.PlayerDetail.AddMoney(180);
            player.PlayerDetail.SendMessage(LanguageMgr.GetTranslation("GameServer.TakeMoneyOfEntertamainRoom.Msg"));
          }
          player.PlayerDetail.ClearFightBag();
        }
        else
        {
          player.PlayerDetail.AddPrestige(flag, this.RoomType);
          if (!player.PlayerDetail.PlayerCharacter.IsAutoBot)
            player.PlayerDetail.RingstationResult(flag);
        }
        pkg.WriteInt(player.Id);
        pkg.WriteBoolean(flag);
        pkg.WriteInt(player.Grade);
        pkg.WriteInt(player.PlayerDetail.PlayerCharacter.GP);
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
        pkg.WriteInt(0);
        pkg.WriteInt(0);
        pkg.WriteInt(0);
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
        pkg.WriteInt(player.GainOffer);
        pkg.WriteInt(0);
        pkg.WriteInt(player.CanTakeOut);
        player.PlayerDetail.OnGameOver((AbstractGame) this, player.Team == num1, player.GainGP);
      }
      pkg.WriteInt(0);
      pkg.WriteInt(0);
      pkg.WriteInt(0);
      this.SendToAll(pkg);
      this.OnGameOverred();
      lock (this.m_players)
        this.m_players.Clear();
      base.Stop();
    }

    private int method_66(List<Player> players, int int_6)
    {
      if (this.RoomType == eRoomType.Match)
      {
        StringBuilder stringBuilder1 = new StringBuilder(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg5"));
        StringBuilder stringBuilder2 = new StringBuilder(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg5"));
        IGamePlayer gamePlayer1 = (IGamePlayer) null;
        IGamePlayer gamePlayer2 = (IGamePlayer) null;
        int num = 0;
        foreach (Player player in players)
        {
          if (player.Team == int_6)
          {
            stringBuilder1.Append(string.Format("[{0}]", (object) player.PlayerDetail.PlayerCharacter.NickName));
            gamePlayer1 = player.PlayerDetail;
          }
          else
          {
            stringBuilder2.Append(string.Format("{0}", (object) player.PlayerDetail.PlayerCharacter.NickName));
            gamePlayer2 = player.PlayerDetail;
            ++num;
          }
        }
        if (gamePlayer2 != null)
        {
          stringBuilder1.Append(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg1") + gamePlayer2.PlayerCharacter.ConsortiaName + LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg2"));
          stringBuilder2.Append(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg3") + gamePlayer1.PlayerCharacter.ConsortiaName + LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg4"));
          int riches = 0;
          if (this.GameType == eGameType.Guild)
            riches = num + this.TotalHurt / 2000;
          gamePlayer1.ConsortiaFight(gamePlayer1.PlayerCharacter.ConsortiaID, gamePlayer2.PlayerCharacter.ConsortiaID, this.Players, this.RoomType, this.GameType, this.TotalHurt, players.Count);
          if (gamePlayer1.ServerID != gamePlayer2.ServerID)
            gamePlayer2.ConsortiaFight(gamePlayer1.PlayerCharacter.ConsortiaID, gamePlayer2.PlayerCharacter.ConsortiaID, this.Players, this.RoomType, this.GameType, this.TotalHurt, players.Count);
          if (this.GameType == eGameType.Guild)
            gamePlayer1.SendConsortiaFight(gamePlayer1.PlayerCharacter.ConsortiaID, riches, stringBuilder1.ToString());
          return riches;
        }
      }
      return 0;
    }

    public bool CanGameOver()
    {
      if (this.RoomType == eRoomType.FightFootballTime && this.TurnIndex > 7)
        return true;
      bool flag1 = true;
      bool flag2 = true;
      foreach (Physics physics in this.list_5)
      {
        if (physics.IsLiving)
        {
          flag1 = false;
          break;
        }
      }
      foreach (Physics physics in this.list_6)
      {
        if (physics.IsLiving)
        {
          flag2 = false;
          break;
        }
      }
      return flag1 || flag2;
    }

    public override Player RemovePlayer(IGamePlayer gp, bool IsKick)
    {
      Player player = base.RemovePlayer(gp, IsKick);
      if (player != null && player.IsLiving && this.GameState != eGameState.Loading)
      {
        gp.RemoveGP(gp.PlayerCharacter.Grade * 12);
        string string_0 = (string) null;
        string string_1 = (string) null;
        if (this.RoomType == eRoomType.Match)
        {
          if (this.GameType == eGameType.Guild)
          {
            string_0 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg6", (object) (gp.PlayerCharacter.Grade * 12), (object) 15);
            gp.RemoveOffer(15);
            string_1 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg7", (object) gp.PlayerCharacter.NickName, (object) (gp.PlayerCharacter.Grade * 12), (object) 15);
          }
          else if (this.GameType == eGameType.Free)
          {
            string_0 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg6", (object) (gp.PlayerCharacter.Grade * 12), (object) 5);
            gp.RemoveOffer(5);
            string_1 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg7", (object) gp.PlayerCharacter.NickName, (object) (gp.PlayerCharacter.Grade * 12), (object) 5);
          }
        }
        else
        {
          string_0 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg4", (object) (gp.PlayerCharacter.Grade * 12));
          string_1 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg5", (object) gp.PlayerCharacter.NickName, (object) (gp.PlayerCharacter.Grade * 12));
        }
        this.method_59(gp, string_0, string_1, 3);
        if (this.GetSameTeam() && this.CurrentLiving != null)
        {
          this.CurrentLiving.StopAttacking();
          this.CheckState(0);
        }
      }
      return player;
    }

    public override void CheckState(int delay)
    {
      this.AddAction((IAction) new CheckPVPGameStateAction(delay));
    }
  }
}
