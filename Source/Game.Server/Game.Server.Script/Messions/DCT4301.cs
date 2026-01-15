// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DCT4301
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DCT4301 : AMissionControl
  {
    private SimpleBoss m_boss = (SimpleBoss) null;
    private int kill = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private SimpleNpc npc;
    private int npcID2 = 4301;
    private int npcID = 4303;
    private int bossID = 4304;

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
      int[] npcIds1 = new int[3]
      {
        this.bossID,
        this.npcID,
        this.npcID2
      };
      int[] npcIds2 = new int[0];
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/effect/4/Gate.swf", "game.asset.Gate");
      this.Game.SetMap(1142);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_boss = this.Game.CreateBoss(this.bossID, 1520, 350, -1, 1, "NoBlood");
      this.npc = this.Game.CreateNpc(this.npcID2, 340, 750, 1, 0);
      this.npc.FallFrom(this.npc.X, this.npc.Y, "", 0, 0, 2000);
      this.Game.CreatePhysicalObj(1500, 250, "door", "", "start", 1, 0);
      this.Game.SendGameObjectFocus(1, "door", 2000, 3000);
    }

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex > 1)
      {
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
      if (this.npc == null || this.npc.IsLiving)
        return;
      this.npc = this.Game.CreateNpc(this.npcID2, 340, 750, 1, 0);
      this.npc.FallFrom(this.npc.X, this.npc.Y, "", 0, 0, 2000);
    }

    public override bool CanGameOver()
    {
      if (this.npc.FindCount != 3)
        return false;
      ++this.kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.npc.FindCount == 3)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
