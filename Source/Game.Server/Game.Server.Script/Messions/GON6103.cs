// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.GON6103
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class GON6103 : AMissionControl
  {
    private static string[] KillChat = new string[2]
    {
      "Gửi cho bạn trở về nhà!",
      "Một mình, bạn có ảo tưởng có thể đánh bại tôi?"
    };
    private static string[] ShootedChat = new string[2]
    {
      " Đau ah! Đau ...",
      "Quốc vương vạn tuế ..."
    };
    private int IsSay = 0;
    private int bossID = 6131;
    private SimpleBoss m_boss;
    private PhysicalObj m_front;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      return score > 825 ? 2 : (score > 725 ? 1 : 0);
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      this.Game.AddLoadingFile(2, "image/game/living/Living189.swf", "game.living.Living189");
      int[] npcIds = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1167);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_boss = this.Game.CreateBoss(this.bossID, 1250, 700, -1, 1, "");
      this.m_front = (PhysicalObj) this.Game.Createlayer(1245, 520, "font", "game.living.Living189", "stand", 1, 0);
      this.m_boss.FallFrom(this.m_boss.X, this.m_boss.Y, "", 0, 0, 1000);
      this.m_boss.SetRelateDemagemRect(-34, -35, 100, 70);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.IsSay = 0;
    }

    public override bool CanGameOver()
    {
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
  }
}
