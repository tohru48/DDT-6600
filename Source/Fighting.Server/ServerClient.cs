// Decompiled with JetBrains decompiler
// Type: Fighting.Server.ServerClient
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Bussiness;
using Bussiness.Managers;
using Fighting.Server.GameObjects;
using Fighting.Server.Games;
using Fighting.Server.Rooms;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using log4net;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

#nullable disable
namespace Fighting.Server
{
  public class ServerClient : BaseClient
  {
    private static readonly ILog ilog_1 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private RSACryptoServiceProvider rsacryptoServiceProvider_0;
    private FightServer fightServer_0;
    private Dictionary<int, ProxyRoom> dictionary_0;

    protected override void OnConnect()
    {
      base.OnConnect();
      this.rsacryptoServiceProvider_0 = new RSACryptoServiceProvider();
      RSAParameters rsaParameters = this.rsacryptoServiceProvider_0.ExportParameters(false);
      this.method_5(rsaParameters.Modulus, rsaParameters.Exponent);
    }

    protected override void OnDisconnect()
    {
      base.OnDisconnect();
      this.rsacryptoServiceProvider_0 = (RSACryptoServiceProvider) null;
    }

    public override void OnRecvPacket(GSPacketIn pkg)
    {
      switch (pkg.Code)
      {
        case 1:
          this.HandleLogin(pkg);
          break;
        case 2:
          this.HanleSendToGame(pkg);
          break;
        case 3:
          this.method_3(pkg);
          break;
        case 19:
          this.method_4(pkg);
          break;
        case 36:
          this.yytValkjc1(pkg);
          break;
        case 64:
          this.HandleGameRoomCreate(pkg);
          break;
        case 65:
          this.HandleGameRoomCancel(pkg);
          break;
        case 77:
          this.HandleConsortiaAlly(pkg);
          break;
        case 83:
          this.method_2(pkg);
          break;
      }
    }

    private void yytValkjc1(GSPacketIn gspacketIn_0)
    {
      BaseGame game = GameMgr.FindGame(gspacketIn_0.ClientID);
      if (game == null)
        return;
      game.Resume();
      if (gspacketIn_0.ReadBoolean())
      {
        Player player = game.FindPlayer(gspacketIn_0.Parameter1);
        ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(gspacketIn_0.Parameter2);
        if (player != null && itemTemplate != null)
          player.UseItem(itemTemplate);
      }
    }

    private void method_2(GSPacketIn gspacketIn_0)
    {
      BaseGame game = GameMgr.FindGame(gspacketIn_0.ClientID);
      if (game == null)
        return;
      Player player = game.FindPlayer(gspacketIn_0.Parameter1);
      if (player != null)
      {
        GSPacketIn pkg = new GSPacketIn((short) 83, player.PlayerDetail.PlayerCharacter.ID);
        game.SendToAll(pkg);
        game.RemovePlayer(player.PlayerDetail, false);
        ProxyRoom roomUnsafe = ProxyRoomMgr.GetRoomUnsafe((game as BattleGame).Red.RoomId);
        if (roomUnsafe != null && !roomUnsafe.RemovePlayer(player.PlayerDetail))
          ProxyRoomMgr.GetRoomUnsafe((game as BattleGame).Blue.RoomId)?.RemovePlayer(player.PlayerDetail);
      }
    }

    public void HandleConsortiaAlly(GSPacketIn pkg)
    {
      BaseGame game = GameMgr.FindGame(pkg.ClientID);
      if (game == null)
        return;
      game.ConsortiaAlly = pkg.ReadInt();
      game.RichesRate = pkg.ReadInt();
    }

    private void method_3(GSPacketIn gspacketIn_0)
    {
      BaseGame game = GameMgr.FindGame(gspacketIn_0.ClientID);
      if (game == null)
        return;
      Player player = game.FindPlayer(gspacketIn_0.Parameter1);
      GSPacketIn pkg = new GSPacketIn((short) 3);
      pkg.WriteInt(3);
      pkg.WriteString(LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg6", (object) (player.PlayerDetail.PlayerCharacter.Grade * 12), (object) 15));
      player.PlayerDetail.SendTCP(pkg);
      pkg.ClearContext();
      pkg.WriteInt(3);
      pkg.WriteString(LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg7", (object) player.PlayerDetail.PlayerCharacter.NickName, (object) (player.PlayerDetail.PlayerCharacter.Grade * 12), (object) 15));
      game.SendToAll(pkg, player.PlayerDetail);
    }

    private void method_4(GSPacketIn gspacketIn_0)
    {
      BaseGame game = GameMgr.FindGame(gspacketIn_0.ClientID);
      if (game == null)
        return;
      Player player = game.FindPlayer(gspacketIn_0.ReadInt());
      bool val = gspacketIn_0.ReadBoolean();
      string str = gspacketIn_0.ReadString();
      if (player != null)
      {
        GSPacketIn pkg = new GSPacketIn((short) 19);
        pkg.ClientID = player.PlayerDetail.PlayerCharacter.ID;
        pkg.WriteInt(4);
        pkg.WriteByte((byte) 5);
        pkg.WriteBoolean(val);
        pkg.WriteString(player.PlayerDetail.PlayerCharacter.NickName);
        pkg.WriteString(str);
        if (val)
          game.SendToTeam(gspacketIn_0, player.Team);
        else
          game.SendToAll(pkg);
      }
    }

    public void HandleLogin(GSPacketIn pkg)
    {
      string[] strArray = Encoding.UTF8.GetString(this.rsacryptoServiceProvider_0.Decrypt(pkg.ReadBytes(), false)).Split(',');
      if (strArray.Length == 2)
      {
        this.rsacryptoServiceProvider_0 = (RSACryptoServiceProvider) null;
        int.Parse(strArray[0]);
        this.Strict = false;
      }
      else
      {
        ServerClient.ilog_1.ErrorFormat("Error Login Packet from {0}", (object) this.TcpEndpoint);
        this.Disconnect();
      }
    }

    public void HandleGameRoomCreate(GSPacketIn pkg)
    {
      int num1 = pkg.ReadInt();
      int npcId = pkg.ReadInt();
      bool isAutoBot = pkg.ReadBoolean();
      bool flag1 = pkg.ReadBoolean();
      bool flag2 = pkg.ReadBoolean();
      int num2 = pkg.ReadInt();
      int num3 = pkg.ReadInt();
      int num4 = pkg.ReadInt();
      int length = pkg.ReadInt();
      int totallevel = 0;
      int totalFightPower = 0;
      int num5 = 0;
      IGamePlayer[] players = new IGamePlayer[length];
      for (int index1 = 0; index1 < length; ++index1)
      {
        PlayerInfo character = new PlayerInfo();
        ProxyPlayerInfo proxyPlayer = new ProxyPlayerInfo();
        proxyPlayer.ZoneId = pkg.ReadInt();
        proxyPlayer.ZoneName = pkg.ReadString();
        character.ID = pkg.ReadInt();
        character.NickName = pkg.ReadString();
        character.Sex = pkg.ReadBoolean();
        character.typeVIP = pkg.ReadByte();
        character.VIPLevel = pkg.ReadInt();
        character.Hide = pkg.ReadInt();
        character.Style = pkg.ReadString();
        proxyPlayer.RedFootballStyle = pkg.ReadString();
        proxyPlayer.BlueFootballStyle = pkg.ReadString();
        character.Colors = pkg.ReadString();
        character.Skin = pkg.ReadString();
        character.Offer = pkg.ReadInt();
        character.GP = pkg.ReadInt();
        character.Grade = pkg.ReadInt();
        character.Repute = pkg.ReadInt();
        character.ConsortiaID = pkg.ReadInt();
        character.ConsortiaName = pkg.ReadString();
        character.ConsortiaLevel = pkg.ReadInt();
        character.ConsortiaRepute = pkg.ReadInt();
        character.badgeID = pkg.ReadInt();
        character.weaklessGuildProgress = Base64.decodeToByteArray(pkg.ReadString());
        character.Honor = pkg.ReadString();
        character.Attack = pkg.ReadInt();
        character.Defence = pkg.ReadInt();
        character.Agility = pkg.ReadInt();
        character.Luck = pkg.ReadInt();
        character.hp = pkg.ReadInt();
        character.FightPower = pkg.ReadInt();
        character.IsMarried = pkg.ReadBoolean();
        if (character.IsMarried)
        {
          character.SpouseID = pkg.ReadInt();
          character.SpouseName = pkg.ReadString();
        }
        character.IsAutoBot = isAutoBot;
        totalFightPower += character.FightPower;
        proxyPlayer.BaseAttack = pkg.ReadDouble();
        proxyPlayer.BaseDefence = pkg.ReadDouble();
        proxyPlayer.BaseAgility = pkg.ReadDouble();
        proxyPlayer.BaseBlood = pkg.ReadDouble();
        proxyPlayer.TemplateId = pkg.ReadInt();
        proxyPlayer.WeaponStrengthLevel = pkg.ReadInt();
        int num6 = pkg.ReadInt();
        if (num6 > 0)
        {
          proxyPlayer.GoldTemplateId = num6;
          proxyPlayer.goldBeginTime = pkg.ReadDateTime();
          proxyPlayer.goldValidDate = pkg.ReadInt();
        }
        proxyPlayer.CanUserProp = pkg.ReadBoolean();
        proxyPlayer.SecondWeapon = pkg.ReadInt();
        proxyPlayer.StrengthLevel = pkg.ReadInt();
        proxyPlayer.Healstone = pkg.ReadInt();
        proxyPlayer.HealstoneCount = pkg.ReadInt();
        proxyPlayer.Double_0 = pkg.ReadDouble();
        proxyPlayer.OfferAddPlus = pkg.ReadDouble();
        proxyPlayer.AntiAddictionRate = pkg.ReadDouble();
        proxyPlayer.ServerId = pkg.ReadInt();
        proxyPlayer.DragonBoatOpen = pkg.ReadBoolean();
        proxyPlayer.DragonBoatAddExpPlus = pkg.ReadInt();
        proxyPlayer.TcpEndPoint = pkg.ReadString();
        UserMatchInfo matchInfo = new UserMatchInfo();
        matchInfo.restCount = pkg.ReadInt();
        matchInfo.maxCount = pkg.ReadInt();
        bool flag3 = pkg.ReadBoolean();
        UsersPetinfo pet = (UsersPetinfo) null;
        if (flag3)
        {
          pet = new UsersPetinfo();
          pet.Place = pkg.ReadInt();
          pet.TemplateID = pkg.ReadInt();
          pet.ID = pkg.ReadInt();
          pet.Name = pkg.ReadString();
          pet.UserID = pkg.ReadInt();
          pet.Level = pkg.ReadInt();
          pet.Skill = pkg.ReadString();
          pet.SkillEquip = pkg.ReadString();
        }
        List<BufferInfo> infos = new List<BufferInfo>();
        int num7 = pkg.ReadInt();
        for (int index2 = 0; index2 < num7; ++index2)
        {
          BufferInfo bufferInfo = new BufferInfo();
          bufferInfo.Type = pkg.ReadInt();
          bufferInfo.IsExist = pkg.ReadBoolean();
          bufferInfo.BeginDate = pkg.ReadDateTime();
          bufferInfo.ValidDate = pkg.ReadInt();
          bufferInfo.Value = pkg.ReadInt();
          bufferInfo.ValidCount = pkg.ReadInt();
          bufferInfo.TemplateID = pkg.ReadInt();
          if (character != null)
            infos.Add(bufferInfo);
        }
        List<ItemInfo> euipEffects = new List<ItemInfo>();
        int num8 = pkg.ReadInt();
        for (int index3 = 0; index3 < num8; ++index3)
        {
          int templateId = pkg.ReadInt();
          int num9 = pkg.ReadInt();
          ItemInfo fromTemplate = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(templateId), 1, 1);
          fromTemplate.Hole1 = num9;
          euipEffects.Add(fromTemplate);
        }
        List<BufferInfo> fightBuffs = new List<BufferInfo>();
        int num10 = pkg.ReadInt();
        for (int index4 = 0; index4 < num10; ++index4)
        {
          BufferInfo bufferInfo = new BufferInfo();
          bufferInfo.Type = pkg.ReadInt();
          bufferInfo.Value = pkg.ReadInt();
          if (character != null)
            fightBuffs.Add(bufferInfo);
        }
        List<int> horseSkill = new List<int>();
        int num11 = pkg.ReadInt();
        for (int index5 = 0; index5 < num11; ++index5)
        {
          int num12 = pkg.ReadInt();
          horseSkill.Add(num12);
        }
        BatleConfigInfo batleConfig = new BatleConfigInfo();
        batleConfig.MagicHouse = pkg.ReadInt();
        batleConfig.PetFormReduceDamage = pkg.ReadInt();
        num5 = character.ID;
        totallevel += character.Grade;
        players[index1] = (IGamePlayer) new ProxyPlayer(this, character, matchInfo, proxyPlayer, pet, infos, euipEffects, fightBuffs, horseSkill, batleConfig);
        players[index1].CanUseProp = proxyPlayer.CanUserProp;
      }
      ProxyRoom room = new ProxyRoom(ProxyRoomMgr.NextRoomId(), num1, players, this, totallevel, totalFightPower, npcId, isAutoBot);
      room.GuildId = num4;
      room.selfId = num5;
      room.startWithNpc = flag1;
      room.IsFreedom = flag2;
      room.RoomType = (eRoomType) num2;
      room.GameType = (eGameType) num3;
      lock (this.dictionary_0)
      {
        if (!this.dictionary_0.ContainsKey(num1))
          this.dictionary_0.Add(num1, room);
        else
          room = (ProxyRoom) null;
      }
      if (room != null)
        ProxyRoomMgr.AddRoom(room);
      else
        this.RemoveRoom(num1, room);
    }

    public void HandleGameRoomCancel(GSPacketIn pkg)
    {
      ProxyRoom room = (ProxyRoom) null;
      lock (this.dictionary_0)
      {
        if (this.dictionary_0.ContainsKey(pkg.Parameter1))
          room = this.dictionary_0[pkg.Parameter1];
      }
      if (room == null)
        return;
      ProxyRoomMgr.RemoveRoom(room);
    }

    public void HanleSendToGame(GSPacketIn pkg)
    {
      BaseGame game = GameMgr.FindGame(pkg.ClientID);
      if (game == null)
        return;
      GSPacketIn pkg1 = pkg.ReadPacket();
      game.ProcessData(pkg1);
    }

    public void method_5(byte[] m, byte[] e)
    {
      GSPacketIn pkg = new GSPacketIn((short) 0);
      pkg.Write(m);
      pkg.Write(e);
      this.SendTCP(pkg);
    }

    public void SendPacketToPlayer(int playerId, GSPacketIn pkg)
    {
      GSPacketIn pkg1 = new GSPacketIn((short) 32, playerId);
      pkg1.WritePacket(pkg);
      this.SendTCP(pkg1);
    }

    public void SendRemoveRoom(int roomId) => this.SendTCP(new GSPacketIn((short) 65, roomId));

    public void SendToRoom(int roomId, GSPacketIn pkg, IGamePlayer except)
    {
      GSPacketIn pkg1 = new GSPacketIn((short) 67, roomId);
      if (except != null)
      {
        pkg1.Parameter1 = except.PlayerCharacter.ID;
        pkg1.Parameter2 = except.GamePlayerId;
      }
      else
      {
        pkg1.Parameter1 = 0;
        pkg1.Parameter2 = 0;
      }
      pkg1.WritePacket(pkg);
      this.SendTCP(pkg1);
    }

    public void SendStartGame(int roomId, AbstractGame game)
    {
      GSPacketIn pkg = new GSPacketIn((short) 66);
      pkg.Parameter1 = roomId;
      pkg.Parameter2 = game.Id;
      pkg.WriteInt((int) game.RoomType);
      pkg.WriteInt((int) game.GameType);
      pkg.WriteInt(game.TimeType);
      this.SendTCP(pkg);
    }

    public void SendStopGame(int roomId, int gameId)
    {
      this.SendTCP(new GSPacketIn((short) 68)
      {
        Parameter1 = roomId,
        Parameter2 = gameId
      });
    }

    public void SendGamePlayerId(IGamePlayer player)
    {
      this.SendTCP(new GSPacketIn((short) 33)
      {
        Parameter1 = player.PlayerCharacter.ID,
        Parameter2 = player.GamePlayerId
      });
    }

    public void SendDisconnectPlayer(int playerId)
    {
      this.SendTCP(new GSPacketIn((short) 34, playerId));
    }

    public void SendPlayerOnGameOver(int playerId, int gameId, bool isWin, int gainXp)
    {
      GSPacketIn pkg = new GSPacketIn((short) 35, playerId);
      pkg.Parameter1 = gameId;
      pkg.WriteBoolean(isWin);
      pkg.WriteInt(gainXp);
      this.SendTCP(pkg);
    }

    public void SendPlayerUsePropInGame(
      int playerId,
      int bag,
      int place,
      int templateId,
      bool isLiving)
    {
      GSPacketIn pkg = new GSPacketIn((short) 36, playerId);
      pkg.Parameter1 = bag;
      pkg.Parameter2 = place;
      pkg.WriteInt(templateId);
      pkg.WriteBoolean(isLiving);
      this.SendTCP(pkg);
    }

    public void SendPlayerAddGold(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 38, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendFootballTakeOut(int playerId, bool isWin)
    {
      GSPacketIn pkg = new GSPacketIn((short) 87, playerId);
      pkg.WriteBoolean(isWin);
      this.SendTCP(pkg);
    }

    public void SendPlayerAddMoney(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 74, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerAddActiveMoney(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 89, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerAddGiftToken(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 75, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerRemoveHealstone(int playerId)
    {
      this.SendTCP(new GSPacketIn((short) 73, playerId));
    }

    public void SendPlayerAddMedal(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 76, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerAddLeagueMoney(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 84, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerAddPrestige(int playerId, bool isWin, eRoomType roomType)
    {
      GSPacketIn pkg = new GSPacketIn((short) 85, playerId);
      pkg.Parameter1 = (int) roomType;
      pkg.WriteBoolean(isWin);
      this.SendTCP(pkg);
    }

    public void SendRingstationResult(int playerId, bool isWin)
    {
      GSPacketIn pkg = new GSPacketIn((short) 90, playerId);
      pkg.WriteBoolean(isWin);
      this.SendTCP(pkg);
    }

    public void SendUpdateRestCount(int playerId)
    {
      this.SendTCP(new GSPacketIn((short) 86, playerId));
    }

    public void SendPlayerAddGP(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 39, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerRemoveGP(int playerId, int value)
    {
      this.SendTCP(new GSPacketIn((short) 49, playerId)
      {
        Parameter1 = value
      });
    }

    public void SendPlayerOnKillingLiving(
      int playerId,
      AbstractGame game,
      int type,
      int id,
      bool isLiving,
      int demage)
    {
      GSPacketIn pkg = new GSPacketIn((short) 40, playerId);
      pkg.WriteInt(type);
      pkg.WriteBoolean(isLiving);
      pkg.WriteInt(demage);
      this.SendTCP(pkg);
    }

    public void SendPlayerOnMissionOver(
      int playerId,
      AbstractGame game,
      bool isWin,
      int MissionID,
      int turnNum)
    {
      GSPacketIn pkg = new GSPacketIn((short) 41, playerId);
      pkg.WriteBoolean(isWin);
      pkg.WriteInt(MissionID);
      pkg.WriteInt(turnNum);
      this.SendTCP(pkg);
    }

    public void SendPlayerConsortiaFight(
      int playerId,
      int consortiaWin,
      int consortiaLose,
      Dictionary<int, Player> players,
      eRoomType roomType,
      eGameType gameClass,
      int totalKillHealth)
    {
      GSPacketIn pkg = new GSPacketIn((short) 42, playerId);
      pkg.WriteInt(consortiaWin);
      pkg.WriteInt(consortiaLose);
      pkg.WriteInt(players.Count);
      for (int key = 0; key < players.Count; ++key)
        pkg.WriteInt(players[key].PlayerDetail.PlayerCharacter.ID);
      pkg.WriteByte((byte) roomType);
      pkg.WriteByte((byte) gameClass);
      pkg.WriteInt(totalKillHealth);
      this.SendTCP(pkg);
    }

    public void SendPlayerSendConsortiaFight(
      int playerId,
      int consortiaID,
      int riches,
      string msg)
    {
      GSPacketIn pkg = new GSPacketIn((short) 43, playerId);
      pkg.WriteInt(consortiaID);
      pkg.WriteInt(riches);
      pkg.WriteString(msg);
      this.SendTCP(pkg);
    }

    public void SendPlayerRemoveGold(int playerId, int value)
    {
      GSPacketIn pkg = new GSPacketIn((short) 44, playerId);
      pkg.WriteInt(value);
      this.SendTCP(pkg);
    }

    public void SendPlayerRemoveMoney(int playerId, int value)
    {
      GSPacketIn pkg = new GSPacketIn((short) 45, playerId);
      pkg.WriteInt(value);
      this.SendTCP(pkg);
    }

    public void SendPlayerRemoveOffer(int playerId, int value)
    {
      GSPacketIn pkg = new GSPacketIn((short) 50, playerId);
      pkg.WriteInt(value);
      this.SendTCP(pkg);
    }

    public void SendPlayerAddTemplate(
      int playerId,
      ItemInfo cloneItem,
      eBageType bagType,
      int count)
    {
      if (cloneItem == null)
        return;
      GSPacketIn pkg = new GSPacketIn((short) 48, playerId);
      pkg.WriteInt(cloneItem.TemplateID);
      pkg.WriteByte((byte) bagType);
      pkg.WriteInt(count);
      pkg.WriteInt(cloneItem.ValidDate);
      pkg.WriteBoolean(cloneItem.IsBinds);
      pkg.WriteBoolean(cloneItem.IsUsed);
      this.SendTCP(pkg);
    }

    public void SendConsortiaAlly(int Consortia1, int Consortia2, int GameId)
    {
      GSPacketIn pkg = new GSPacketIn((short) 77);
      pkg.WriteInt(Consortia1);
      pkg.WriteInt(Consortia2);
      pkg.WriteInt(GameId);
      this.SendTCP(pkg);
    }

    public void SendBeginFightNpc(int playerId, int RoomType, int GameType, int OrientRoomId)
    {
      GSPacketIn pkg = new GSPacketIn((short) 88);
      pkg.Parameter1 = playerId;
      pkg.WriteInt(RoomType);
      pkg.WriteInt(GameType);
      pkg.WriteInt(OrientRoomId);
      this.SendTCP(pkg);
    }

    public ServerClient(FightServer svr)
      : base(new byte[8192], new byte[8192])
    {
      this.dictionary_0 = new Dictionary<int, ProxyRoom>();
      this.fightServer_0 = svr;
    }

    public override string ToString()
    {
      return string.Format("Server Client: {0} IsConnected:{1}  RoomCount:{2}", (object) 0, (object) this.IsConnected, (object) this.dictionary_0.Count);
    }

    public void RemoveRoom(int orientId, ProxyRoom room)
    {
      bool flag = false;
      lock (this.dictionary_0)
      {
        if (this.dictionary_0.ContainsKey(orientId) && this.dictionary_0[orientId] == room)
          flag = this.dictionary_0.Remove(orientId);
      }
      if (!flag)
        return;
      this.SendRemoveRoom(orientId);
    }
  }
}
