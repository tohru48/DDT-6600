// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.ETN3103
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class ETN3103 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss m_boss = (SimpleBoss) null;
    private SimpleBoss m_king = (SimpleBoss) null;
    private int m_kill = 0;
    private int IsSay = 0;
    private int bossID = 3108;
    private int bossID2 = 3109;
    private int npcID = 3106;
    private int npcID2 = 3110;
    private int npcID3 = 3111;
    private PhysicalObj m_moive;
    private PhysicalObj m_front = (PhysicalObj) null;
    private static string[] KillChat = new string[3]
    {
      "A~đau quá!",
      "Ngươi dám đối mặt?",
      "Đánh nữa ta đánh trả đó!"
    };
    private static string[] ShootedChat = new string[2]
    {
      "Ah ~ ~ Tại sao bạn tấn công?<br/>Tôi đang làm?",
      "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu?<br/>Tôi phải chiến đấu ..."
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1330)
        return 3;
      if (score > 1150)
        return 2;
      return score > 970 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds1 = new int[4]
      {
        this.bossID,
        this.bossID2,
        this.npcID,
        this.npcID2
      };
      int[] npcIds2 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/54.swf", "tank.resource.bombs.Bomb54");
      this.Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
      this.Game.AddLoadingFile(2, "image/game/effect/3/buff.swf", "asset.game.4.buff");
      this.Game.AddLoadingFile(2, "image/game/effect/3/dici.swf", "asset.game.4.dici");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ClanBrotherAsset");
      this.Game.AddLoadingFile(2, "image/game/living/living117.swf", "living117_fla.walk_6");
      this.Game.SetMap(1124);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "3103";
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(650, 400, "front", "game.asset.living.ClanBrotherAsset", "out", 1, 0);
      this.m_king = this.Game.CreateBoss(this.bossID, 1360, 357, -1, 1, "");
      this.m_king.FallFrom(this.m_king.X, this.m_king.Y, "", 0, 0, 1000, (LivingCallBack) null);
      this.m_king.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
      this.boss = this.Game.CreateBoss(this.bossID2, (int) byte.MaxValue, 357, 1, 1, "");
      this.boss.FallFrom(this.boss.X, this.boss.Y, "", 0, 0, 1000, (LivingCallBack) null);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.m_moive.PlayMovie("in", 5000, 0);
      this.m_front.PlayMovie("in", 5000, 0);
      this.m_moive.PlayMovie("out", 9000, 0);
      this.m_front.PlayMovie("out", 9400, 0);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_front == null)
        return;
      this.Game.RemovePhysicalObj(this.m_front, true);
      this.m_front = (PhysicalObj) null;
    }

    public override bool CanGameOver()
    {
      if (this.m_king == null || this.m_king.IsLiving || this.boss == null || this.boss.IsLiving)
        return false;
      ++this.m_kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      bool flag = true;
      foreach (Physics allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving)
          flag = false;
      }
      if (this.m_king != null && !this.m_king.IsLiving && this.boss != null && !this.boss.IsLiving && !flag)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show4.jpg", "")
      });
    }

    public override void DoOther()
    {
      base.DoOther();
      if (this.m_king == null)
        return;
      if (this.m_king.IsLiving)
      {
        int index = this.Game.Random.Next(0, ETN3103.KillChat.Length);
        this.m_king.Say(ETN3103.KillChat[index], 0, 0);
        this.boss.Say(ETN3103.KillChat[index], 0, 0);
      }
      else
      {
        int index = this.Game.Random.Next(0, ETN3103.KillChat.Length);
        this.m_king.Say(ETN3103.KillChat[index], 0, 0);
        this.boss.Say(ETN3103.KillChat[index], 0, 0);
      }
    }

    public override void OnShooted()
    {
      if (this.IsSay != 0)
        return;
      if (this.m_king.IsLiving)
      {
        int index = this.Game.Random.Next(0, ETN3103.ShootedChat.Length);
        this.m_king.Say(ETN3103.ShootedChat[index], 0, 1500);
        this.boss.Say(ETN3103.ShootedChat[index], 0, 1500);
      }
      else
      {
        int index = this.Game.Random.Next(0, ETN3103.ShootedChat.Length);
        this.m_king.Say(ETN3103.ShootedChat[index], 0, 1500);
        this.boss.Say(ETN3103.ShootedChat[index], 0, 1500);
      }
      this.IsSay = 1;
    }
  }
}
