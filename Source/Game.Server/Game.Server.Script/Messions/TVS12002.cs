// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.TVS12002
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class TVS12002 : AMissionControl
  {
    private static string[] KillChat = new string[2]
    {
      "Không có gì phải sợ, đau đớn sẻ qua",
      "Kẻ tầm thường và thấp hèn."
    };
    private static string[] ShootedChat = new string[2]
    {
      "Chỉ được vậy thôi à ?…",
      "Sức mạnh cũng thường…"
    };
    private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
    private int IsSay = 0;
    private int bossID = 12008;
    private int bossID2 = 12006;
    private int npcID = 12007;
    private SimpleBoss m_boss;
    private SimpleBoss boss;
    private PhysicalObj m_moive;
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
      this.Game.AddLoadingFile(1, "bombs/174.swf", "tank.resource.bombs.Bomb174");
      this.Game.AddLoadingFile(2, "image/game/effect/9/biaoji.swf", "asset.game.nine.biaoji");
      this.Game.AddLoadingFile(2, "image/game/effect/9/dapao.swf", "asset.game.nine.dapao");
      this.Game.AddLoadingFile(2, "image/game/effect/5/xiaopao.swf", "asset.game.4.xiaopao");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ducaizheAsset");
      int[] npcIds = new int[3]
      {
        this.bossID,
        this.bossID2,
        this.npcID
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1208);
    }

    public static void msg(Living living, Living target, int damageAmount, int criticalAmount)
    {
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1300, 730, "font", "game.asset.living.ducaizheAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 1500, 800, -1, 1, "");
      this.SomeNpc.Add(this.Game.CreateNpc(this.bossID2, 150, 700, 1, 1));
      this.m_boss.FallFrom(this.m_boss.X, this.m_boss.Y, "", 0, 0, 1000, (LivingCallBack) null);
      this.m_boss.SetRelateDemagemRect(-21, -79, 72, 91);
      this.m_boss.AddDelay(10);
      this.m_boss.Say("Nếu chiến thắng ta thì các ngươi sẻ tiếp cận được vòng xoáy thời gian!", 0, 6000);
      this.m_moive.PlayMovie("in", 9000, 0);
      this.m_front.PlayMovie("in", 9000, 0);
      this.m_moive.PlayMovie("out", 15000, 0);
      this.Game.BossCardCount = 1;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

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
      if (this.m_front == null)
        return;
      this.Game.RemovePhysicalObj(this.m_front, true);
      this.m_front = (PhysicalObj) null;
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
      bool flag = true;
      foreach (Physics allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving)
          flag = false;
      }
      if (this.m_boss.IsLiving || flag)
        return;
      this.Game.IsWin = true;
    }
  }
}
