// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CSM1073
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CSM1073 : AMissionControl
  {
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private int IsSay = 0;
    private int bossID = 1003;
    private int npcID = 1009;
    private static string[] KillChat = new string[2]
    {
      "送你回老家！",
      "就凭你还妄想能够打败我？"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呦！很痛…",
      "我还顶的住…"
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      int[] npcIds = new int[2]{ this.bossID, this.npcID };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1073);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(680, 330, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 770, -1500, -1, 4, "");
      this.m_boss.FallFrom(770, 301, "fall", 0, 2, 1000);
      this.m_boss.SetRelateDemagemRect(34, -35, 11, 18);
      this.m_boss.AddDelay(10);
      this.m_boss.Say("你们胆敢闯入我的地盘，准备受死吧！", 0, 6000);
      this.m_boss.PlayMovie("call", 5900, 0);
      this.m_moive.PlayMovie("in", 9000, 0);
      this.m_boss.PlayMovie("weakness", 10000, 5000);
      this.m_front.PlayMovie("in", 9000, 0);
      this.m_moive.PlayMovie("out", 15000, 0);
      this.Game.BossCardCount = 1;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.IsSay = 0;
      if (this.Game.TurnIndex <= 1)
        return;
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_front != null)
      {
        this.Game.RemovePhysicalObj(this.m_front, true);
        this.m_front = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      base.CanGameOver();
      return this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1 || !this.m_boss.IsLiving;
    }

    public override int UpdateUIData()
    {
      if (this.m_boss == null)
        return 0;
      return !this.m_boss.IsLiving ? 1 : base.UpdateUIData();
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (!this.m_boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void DoOther()
    {
      base.DoOther();
      if (this.m_boss == null)
        return;
      int index = this.Game.Random.Next(0, CSM1073.KillChat.Length);
      if (this.m_boss == null)
        return;
      this.m_boss.Say(CSM1073.KillChat[index], 0, 0);
    }

    public override void OnShooted()
    {
      if (this.m_boss == null || !this.m_boss.IsLiving || this.IsSay != 0)
        return;
      int index = this.Game.Random.Next(0, CSM1073.ShootedChat.Length);
      this.m_boss.Say(CSM1073.ShootedChat[index], 0, 1500);
      this.IsSay = 1;
    }
  }
}
