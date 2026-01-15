// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CidadeCybernetica27666
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CidadeCybernetica27666 : AMissionControl
  {
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss bossL = (SimpleBoss) null;
    private SimpleBoss bossR = (SimpleBoss) null;
    private int bossID = 70016;
    private int kill = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private PhysicalObj front;

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
      int[] npcIds1 = new int[1]{ this.bossID };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");
      this.Game.SetMap(1278);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_king = this.Game.CreateBoss(this.bossID, 803, -1081, -1, 1, "");
      this.m_king.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
      this.m_king.Say(LanguageMgr.GetTranslation("Você vai morrer !!"), 0, 200, 0);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6100, 0);
      this.m_moive.PlayMovie("out", 10000, 1000);
      this.m_front.PlayMovie("out", 9900, 0);
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.bossL != null)
        ;
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
      if (this.m_king == null || this.m_king.IsLiving)
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
      if (this.m_king != null && !this.m_king.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
