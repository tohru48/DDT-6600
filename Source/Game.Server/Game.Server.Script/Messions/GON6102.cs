// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.GON6102
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class GON6102 : AMissionControl
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
    private int bossID = 6123;
    private int npcID = 6121;
    private int npcID2 = 6122;
    private SimpleNpc npc;
    private SimpleBoss m_boss;
    private SimpleBoss m_king;
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
      this.Game.AddLoadingFile(2, "image/game/living/Living190.swf", "game.living.Living190");
      int[] npcIds = new int[3]
      {
        this.bossID,
        this.npcID,
        this.npcID2
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1166);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_boss = this.Game.CreateBoss(this.bossID, 1950, 700, -1, 1, "");
      this.m_front = (PhysicalObj) this.Game.Createlayer(1100, 1080, "font", "game.living.Living190", "stand", 1, 0);
      this.m_boss.FallFrom(this.m_boss.X, this.m_boss.Y, "", 0, 0, 1000);
      this.m_boss.SetRelateDemagemRect(-34, -35, 100, 70);
      this.npc = this.Game.CreateNpc(this.npcID, 10, 750, 1, 10);
      this.npc.FallFrom(this.npc.X, this.npc.Y, "", 0, 0, 1000);
      this.npc.CallFuction(new LivingCallBack(this.Go), 1200);
      this.m_king = this.Game.CreateBoss(this.npcID2, 10, 750, 1, 1, "");
      this.m_king.FallFrom(this.m_king.X, this.m_king.Y, "", 0, 0, 1000);
      this.m_king.CallFuction(new LivingCallBack(this.Run), 2200);
    }

    private void Go()
    {
      this.npc.MoveTo(605, this.npc.Y, "walk", 0, "", 7, new LivingCallBack(this.FlyUp));
    }

    private void FlyUp()
    {
      this.npc.MoveTo(this.npc.X, this.npc.Y - 110, "flyup", 0, "", 3, new LivingCallBack(this.FlyLR), 2500);
    }

    private void FlyLR()
    {
      this.npc.MoveTo(this.npc.X + 170, this.npc.Y, "flyLR", 0, "", 3, (LivingCallBack) null);
    }

    private void Run()
    {
      this.m_king.MoveTo(605, this.m_king.Y, "walk", 0, "", 7, new LivingCallBack(this.WalkUp));
    }

    private void WalkUp()
    {
      this.m_king.MoveTo(this.m_king.X, this.m_king.Y - 110, "flyup", 0, "", 3, new LivingCallBack(this.WalkLR), 2500);
    }

    private void WalkLR()
    {
      this.m_king.MoveTo(this.m_king.X + 90, this.m_king.Y, "flyLR", 0, "", 3, (LivingCallBack) null);
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
