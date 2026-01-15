// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DLT5303
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DLT5303 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss m_boss = (SimpleBoss) null;
    private SimpleBoss m_king = (SimpleBoss) null;
    private PhysicalObj m_door = (PhysicalObj) null;
    private int npcID = 5322;
    private int npcID2 = 5323;
    private int npcID3 = 5324;
    private int bossID = 5321;
    private int bossID2 = 5121;
    private int bossID3 = 5304;
    private int kill = 0;
    private int IsTrue = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1750)
        return 3;
      if (score > 1675)
        return 2;
      return score > 1600 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds1 = new int[4]
      {
        this.bossID,
        this.npcID,
        this.npcID2,
        this.npcID3
      };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.hongpaoxiaoemoAsset");
      this.Game.AddLoadingFile(2, "image/game/effect/5/heip.swf", "asset.game.4.heip");
      this.Game.AddLoadingFile(2, "image/game/effect/5/lanhuo.swf", "asset.game.4.lanhuo");
      this.Game.AddLoadingFile(2, "image/game/living/living145.swf", "game.living.Living145");
      this.Game.AddLoadingFile(2, "image/game/living/living153.swf", "game.living.Living153");
      this.Game.SetMap(1153);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(870, 450, "font", "game.asset.living.hongpaoxiaoemoAsset", "out", 1, 1);
      this.boss = this.Game.CreateBoss(this.bossID, 1000, 400, -1, 0, "");
      this.boss.SetRelateDemagemRect(-21, -79, 72, 51);
      this.boss.Say("Can đảm lấm bọn nhọc, địa ngục cũng dám đến ! Ha ha ha...", 0, 1000);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6100, 0);
      this.m_moive.PlayMovie("out", 10000, 1000);
      this.m_front.PlayMovie("out", 9900, 0);
      this.m_door = this.Game.CreatePhysicalObj(0, 0, "door", "", "start", 1, 0);
    }

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
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
      if (this.boss != null && !this.boss.IsLiving && this.IsTrue == 0)
      {
        ++this.kill;
        this.Game.RemoveLiving(this.boss.Id);
        this.m_boss = this.Game.CreateBoss(this.bossID2, this.boss.X, this.boss.Y, this.boss.Direction, 0, "");
        this.m_boss.MoveTo(1000, 400, "fly", 3000, "", 10, new LivingCallBack(this.Testing2), 3000);
        this.IsTrue = 1;
      }
      if (this.m_boss != null && !this.m_boss.IsLiving && this.IsTrue == 1)
      {
        this.m_king = this.Game.CreateBoss(this.bossID3, 200, 550, 1, 0, "");
        this.m_king.PlayMovie("cool", 0, 0);
        this.IsTrue = 2;
        this.m_door.PlayMovie("end", 2000, 0);
      }
      return this.m_door.CurrentAction == "end";
    }

    private void Testing2()
    {
      if (this.m_boss.X != 1000 || this.m_boss.Y != 400)
        return;
      this.m_boss.ChangeDirection(1, 0);
      this.m_boss.PlayMovie("out", 2000, 0);
      this.m_boss.CallFuction(new LivingCallBack(this.Testing3), 5000);
    }

    private void Testing3() => this.m_boss.Die(0);

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_door.CurrentAction == "end")
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
