// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.GON6101
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Drawing;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class GON6101 : AMissionControl
  {
    private int turn = 0;
    private SimpleBoss m_boss;
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingFront;

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
      this.Game.AddLoadingFile(2, "image/game/thing/bossborn6.swf", "game.asset.living.GuizeAsset");
      this.Game.AddLoadingFile(2, "image/game/effect/6/ball.swf", "asset.game.six.ball");
      this.Game.AddLoadingFile(2, "image/game/effect/6/jifenpai.swf", "asset.game.six.fenshu");
      this.Game.SetMap(1166);
    }

    public override void OnStartGame() => base.OnStartGame();

    private void CreatBall()
    {
      int[] array1 = new int[28]
      {
        1199,
        973,
        842,
        705,
        971,
        1110,
        1240,
        799,
        662,
        556,
        572,
        731,
        926,
        1106,
        587,
        1305,
        775,
        941,
        1127,
        675,
        889,
        1147,
        462,
        493,
        846,
        537,
        771,
        1009
      };
      int[] array2 = new int[28]
      {
        812,
        776,
        718,
        765,
        617,
        648,
        574,
        596,
        624,
        702,
        496,
        472,
        495,
        476,
        345,
        374,
        332,
        338,
        313,
        245,
        196,
        198,
        585,
        411,
        860,
        228,
        (int) sbyte.MaxValue,
        111
      };
      string[] strArray1 = new string[16]
      {
        "s1",
        "s2",
        "s3",
        "s4",
        "s5",
        "double",
        "s1",
        "s2",
        "s3",
        "s4",
        "s5",
        "s1",
        "s2",
        "s3",
        "s4",
        "s5"
      };
      string[] strArray2 = new string[15]
      {
        "s-1",
        "s-2",
        "s-3",
        "s-4",
        "s-5",
        "s-1",
        "s-2",
        "s-3",
        "s-4",
        "s-5",
        "s-1",
        "s-2",
        "s-3",
        "s-4",
        "s-5"
      };
      Point[] array3 = new Point[5]
      {
        new Point(1199, 812),
        new Point(973, 776),
        new Point(842, 718),
        new Point(705, 765),
        new Point(971, 617)
      };
      this.Game.Shuffer<int>(array1);
      this.Game.Shuffer<int>(array2);
      this.Game.Shuffer<Point>(array3);
      for (int index1 = 0; index1 < array3.Length; ++index1)
      {
        int index2 = this.Game.Random.Next(strArray2.Length);
        if (index1 == 3 || index1 == 7 || index1 == 13)
        {
          this.Game.CreateBall(array3[index1].X, array3[index1].Y, strArray2[index2]);
        }
        else
        {
          int index3 = this.Game.Random.Next(strArray1.Length);
          this.Game.CreateBall(array3[index1].X, array3[index1].Y, strArray1[index3]);
        }
      }
      this.Game.CreateBall(900, 500, "s2");
      this.Game.CreateBall(1000, 500, "s3");
      this.Game.CreateBall(1100, 500, "s4");
      this.Game.CreateBall(1200, 500, "s5");
      this.Game.CreateBall(1200, 500, "s6");
      this.Game.CreateBall(800, 600, "s-1");
      this.Game.CreateBall(900, 600, "s-2");
      this.Game.CreateBall(1000, 600, "s-3");
      this.Game.CreateBall(1100, 600, "s-4");
      this.Game.CreateBall(1200, 600, "s-5");
      this.Game.CreateBall(1200, 600, "s-6");
      this.Game.CreateBall(1100, 700, "double");
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      this.Game.ClearBall();
      this.CreatBall();
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= this.turn + 1)
        return;
      if (this.m_kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive, true);
        this.m_kingMoive = (PhysicalObj) null;
      }
      if (this.m_kingFront == null)
        return;
      this.Game.RemovePhysicalObj(this.m_kingFront, true);
      this.m_kingFront = (PhysicalObj) null;
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      return this.m_boss != null && !this.m_boss.IsLiving;
    }

    public override int UpdateUIData() => base.UpdateUIData();

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_boss == null || this.m_boss.IsLiving)
        return;
      this.Game.IsWin = true;
    }
  }
}
