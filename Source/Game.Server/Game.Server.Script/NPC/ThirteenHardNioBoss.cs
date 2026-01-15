// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenHardNioBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirteenHardNioBoss : ABrain
  {
    private int m_attackTurn = 0;
    private static string[] AllAttackChat = new string[3]
    {
      "Địa chấn ! <br/> Thật đáng sợ",
      "Đặt hết vũ khí xuống !",
      "Nhìn bạn cũng có thể có thể chịu được một số ít!"
    };
    private static string[] ShootChat = new string[3]
    {
      "Cảm nhận sức mạnh của ta !",
      "Gửi cho cậu nhưng viên kheo đau khổ",
      "Cho các ngươi nén mùi lợi hại "
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
      "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"
    };
    private static string[] AddBooldChat = new string[3]
    {
      "Xoay xoay ~ <br/> xoay ah xoay ~ ~",
      "Hallelujah ~ <br/> Luyaluya ~ ~",
      "Kì diệu quá! Đã đem đến cho ta sức mạnh siêu phàm !"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "君临天下！！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 0);
      else if (this.m_attackTurn == 0)
      {
        this.NextAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Healing();
        ++this.m_attackTurn;
      }
      else
      {
        this.AllAttack();
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirteenHardNioBoss.KillAttackChat.Length);
      this.Body.Say(ThirteenHardNioBoss.KillAttackChat[index], 1, 1000);
      this.Body.PlayMovie("beatA", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void AllAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, ThirteenHardNioBoss.AllAttackChat.Length);
      this.Body.Say(ThirteenHardNioBoss.AllAttackChat[index], 1, 0);
      this.Body.PlayMovie("beat", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 4000, this.Body.X + 4000, "cry", 3000, (List<Player>) null);
    }

    private void Healing()
    {
      int index = this.Game.Random.Next(0, ThirteenHardNioBoss.AddBooldChat.Length);
      this.Body.Say(ThirteenHardNioBoss.AddBooldChat[index], 1, 0);
      this.Body.SyncAtTime = true;
      this.Body.AddBlood(7500);
      this.Body.PlayMovie("renew", 1000, 4500);
    }

    private void NextAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer.X > this.Body.Y)
        this.Body.ChangeDirection(1, 800);
      else
        this.Body.ChangeDirection(-1, 800);
      this.Body.CurrentDamagePlus = 0.8f;
      int index = this.Game.Random.Next(0, ThirteenHardNioBoss.ShootChat.Length);
      this.Body.Say(ThirteenHardNioBoss.ShootChat[index], 1, 0);
      if (randomPlayer == null || !this.Body.ShootPoint(this.Game.Random.Next(randomPlayer.X - 30, randomPlayer.X + 30), randomPlayer.Y, 61, 1400, 10000, 1, 1.5f, 2300))
        return;
      this.Body.PlayMovie("beat2", 1500, 0);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
