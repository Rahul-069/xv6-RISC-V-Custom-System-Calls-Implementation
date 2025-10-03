
user/_fork:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <custom_atoi>:
#include "kernel/types.h"
#include "user/user.h"

int custom_atoi(const char *str) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    int result = 0;
    int sign = 1;

    // Check for negative sign
    if (*str == '-') {
   6:	00054703          	lbu	a4,0(a0)
   a:	02d00793          	li	a5,45
    int sign = 1;
   e:	4585                	li	a1,1
    if (*str == '-') {
  10:	04f70463          	beq	a4,a5,58 <custom_atoi+0x58>
        sign = -1;
        str++;
    }

    // Convert characters to integer
    while (*str >= '0' && *str <= '9') {
  14:	00054703          	lbu	a4,0(a0)
  18:	fd07079b          	addiw	a5,a4,-48
  1c:	0ff7f793          	zext.b	a5,a5
  20:	4825                	li	a6,9
  22:	4681                	li	a3,0
  24:	4625                	li	a2,9
  26:	02f86463          	bltu	a6,a5,4e <custom_atoi+0x4e>
        result = result * 10 + (*str - '0');
  2a:	0026979b          	slliw	a5,a3,0x2
  2e:	9fb5                	addw	a5,a5,a3
  30:	0017979b          	slliw	a5,a5,0x1
  34:	fd07071b          	addiw	a4,a4,-48
  38:	00f706bb          	addw	a3,a4,a5
        str++;
  3c:	0505                	addi	a0,a0,1
    while (*str >= '0' && *str <= '9') {
  3e:	00054703          	lbu	a4,0(a0)
  42:	fd07079b          	addiw	a5,a4,-48
  46:	0ff7f793          	zext.b	a5,a5
  4a:	fef670e3          	bgeu	a2,a5,2a <custom_atoi+0x2a>
    }

    return sign * result;
}
  4e:	02d5853b          	mulw	a0,a1,a3
  52:	6422                	ld	s0,8(sp)
  54:	0141                	addi	sp,sp,16
  56:	8082                	ret
        str++;
  58:	0505                	addi	a0,a0,1
        sign = -1;
  5a:	55fd                	li	a1,-1
  5c:	bf65                	j	14 <custom_atoi+0x14>

000000000000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	7179                	addi	sp,sp,-48
  60:	f406                	sd	ra,40(sp)
  62:	f022                	sd	s0,32(sp)
  64:	1800                	addi	s0,sp,48
    int pid;

    char buffer[10];
    int n;

    printf("Enter a number to pass to child : ");
  66:	00001517          	auipc	a0,0x1
  6a:	90a50513          	addi	a0,a0,-1782 # 970 <malloc+0xf8>
  6e:	756000ef          	jal	7c4 <printf>

    n=read(0,buffer,sizeof(buffer));
  72:	4629                	li	a2,10
  74:	fd040593          	addi	a1,s0,-48
  78:	4501                	li	a0,0
  7a:	332000ef          	jal	3ac <read>

    if(n<0)
  7e:	04054c63          	bltz	a0,d6 <main+0x78>
  82:	ec26                	sd	s1,24(sp)
    {
        printf("Error reading input\n");
        exit(0);
    }

    buffer[n-1]='\0';
  84:	357d                	addiw	a0,a0,-1
  86:	fe050793          	addi	a5,a0,-32
  8a:	00878533          	add	a0,a5,s0
  8e:	fe050823          	sb	zero,-16(a0)
    int arg=custom_atoi(buffer);
  92:	fd040513          	addi	a0,s0,-48
  96:	f6bff0ef          	jal	0 <custom_atoi>
    pid = forkwitharg(arg);  // Pass test value 42
  9a:	39a000ef          	jal	434 <forkwitharg>
    if(pid < 0){
  9e:	04054663          	bltz	a0,ea <main+0x8c>
        printf("forkwitharg failed\n");
        exit(1);
    }
    
    if(pid == 0){
  a2:	ed29                	bnez	a0,fc <main+0x9e>
        // Child process
        printf("Child process created with argument: %d\n", getforkarg());
  a4:	398000ef          	jal	43c <getforkarg>
  a8:	85aa                	mv	a1,a0
  aa:	00001517          	auipc	a0,0x1
  ae:	91e50513          	addi	a0,a0,-1762 # 9c8 <malloc+0x150>
  b2:	712000ef          	jal	7c4 <printf>
        printf("Child Pid : %u, Parent Pid : %lu\n",getpid(),getppid());
  b6:	35e000ef          	jal	414 <getpid>
  ba:	84aa                	mv	s1,a0
  bc:	388000ef          	jal	444 <getppid>
  c0:	862a                	mv	a2,a0
  c2:	85a6                	mv	a1,s1
  c4:	00001517          	auipc	a0,0x1
  c8:	93450513          	addi	a0,a0,-1740 # 9f8 <malloc+0x180>
  cc:	6f8000ef          	jal	7c4 <printf>
        wait(0);
        printf("In parent process\n");
        printf("Parent Pid : %u, Parent's Parent Pid : %lu\n",getpid(),getppid());
        // wait(0);
    }
    exit(0);
  d0:	4501                	li	a0,0
  d2:	2c2000ef          	jal	394 <exit>
  d6:	ec26                	sd	s1,24(sp)
        printf("Error reading input\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	8c050513          	addi	a0,a0,-1856 # 998 <malloc+0x120>
  e0:	6e4000ef          	jal	7c4 <printf>
        exit(0);
  e4:	4501                	li	a0,0
  e6:	2ae000ef          	jal	394 <exit>
        printf("forkwitharg failed\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	8c650513          	addi	a0,a0,-1850 # 9b0 <malloc+0x138>
  f2:	6d2000ef          	jal	7c4 <printf>
        exit(1);
  f6:	4505                	li	a0,1
  f8:	29c000ef          	jal	394 <exit>
        wait(0);
  fc:	4501                	li	a0,0
  fe:	29e000ef          	jal	39c <wait>
        printf("In parent process\n");
 102:	00001517          	auipc	a0,0x1
 106:	91e50513          	addi	a0,a0,-1762 # a20 <malloc+0x1a8>
 10a:	6ba000ef          	jal	7c4 <printf>
        printf("Parent Pid : %u, Parent's Parent Pid : %lu\n",getpid(),getppid());
 10e:	306000ef          	jal	414 <getpid>
 112:	84aa                	mv	s1,a0
 114:	330000ef          	jal	444 <getppid>
 118:	862a                	mv	a2,a0
 11a:	85a6                	mv	a1,s1
 11c:	00001517          	auipc	a0,0x1
 120:	91c50513          	addi	a0,a0,-1764 # a38 <malloc+0x1c0>
 124:	6a0000ef          	jal	7c4 <printf>
 128:	b765                	j	d0 <main+0x72>

000000000000012a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  extern int main();
  main();
 132:	f2dff0ef          	jal	5e <main>
  exit(0);
 136:	4501                	li	a0,0
 138:	25c000ef          	jal	394 <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	addi	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if(*s == c)
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for(; *s; s++)
 1e0:	0505                	addi	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
      return (char*)s;
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	2485                	addiw	s1,s1,1
 21a:	0344d663          	bge	s1,s4,246 <gets+0x52>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	addi	a1,s0,-81
 224:	4501                	li	a0,0
 226:	186000ef          	jal	3ac <read>
    if(cc < 1)
 22a:	00a05e63          	blez	a0,246 <gets+0x52>
    buf[i++] = c;
 22e:	faf44783          	lbu	a5,-81(s0)
 232:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 236:	01578763          	beq	a5,s5,244 <gets+0x50>
 23a:	0905                	addi	s2,s2,1
 23c:	fd679de3          	bne	a5,s6,216 <gets+0x22>
    buf[i++] = c;
 240:	89a6                	mv	s3,s1
 242:	a011                	j	246 <gets+0x52>
 244:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 246:	99de                	add	s3,s3,s7
 248:	00098023          	sb	zero,0(s3)
  return buf;
}
 24c:	855e                	mv	a0,s7
 24e:	60e6                	ld	ra,88(sp)
 250:	6446                	ld	s0,80(sp)
 252:	64a6                	ld	s1,72(sp)
 254:	6906                	ld	s2,64(sp)
 256:	79e2                	ld	s3,56(sp)
 258:	7a42                	ld	s4,48(sp)
 25a:	7aa2                	ld	s5,40(sp)
 25c:	7b02                	ld	s6,32(sp)
 25e:	6be2                	ld	s7,24(sp)
 260:	6125                	addi	sp,sp,96
 262:	8082                	ret

0000000000000264 <stat>:

int
stat(const char *n, struct stat *st)
{
 264:	1101                	addi	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	e04a                	sd	s2,0(sp)
 26c:	1000                	addi	s0,sp,32
 26e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 270:	4581                	li	a1,0
 272:	162000ef          	jal	3d4 <open>
  if(fd < 0)
 276:	02054263          	bltz	a0,29a <stat+0x36>
 27a:	e426                	sd	s1,8(sp)
 27c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27e:	85ca                	mv	a1,s2
 280:	16c000ef          	jal	3ec <fstat>
 284:	892a                	mv	s2,a0
  close(fd);
 286:	8526                	mv	a0,s1
 288:	134000ef          	jal	3bc <close>
  return r;
 28c:	64a2                	ld	s1,8(sp)
}
 28e:	854a                	mv	a0,s2
 290:	60e2                	ld	ra,24(sp)
 292:	6442                	ld	s0,16(sp)
 294:	6902                	ld	s2,0(sp)
 296:	6105                	addi	sp,sp,32
 298:	8082                	ret
    return -1;
 29a:	597d                	li	s2,-1
 29c:	bfcd                	j	28e <stat+0x2a>

000000000000029e <atoi>:

int
atoi(const char *s)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a4:	00054683          	lbu	a3,0(a0)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	4625                	li	a2,9
 2b2:	02f66863          	bltu	a2,a5,2e2 <atoi+0x44>
 2b6:	872a                	mv	a4,a0
  n = 0;
 2b8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ba:	0705                	addi	a4,a4,1
 2bc:	0025179b          	slliw	a5,a0,0x2
 2c0:	9fa9                	addw	a5,a5,a0
 2c2:	0017979b          	slliw	a5,a5,0x1
 2c6:	9fb5                	addw	a5,a5,a3
 2c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2cc:	00074683          	lbu	a3,0(a4)
 2d0:	fd06879b          	addiw	a5,a3,-48
 2d4:	0ff7f793          	zext.b	a5,a5
 2d8:	fef671e3          	bgeu	a2,a5,2ba <atoi+0x1c>
  return n;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  n = 0;
 2e2:	4501                	li	a0,0
 2e4:	bfe5                	j	2dc <atoi+0x3e>

00000000000002e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ec:	02b57463          	bgeu	a0,a1,314 <memmove+0x2e>
    while(n-- > 0)
 2f0:	00c05f63          	blez	a2,30e <memmove+0x28>
 2f4:	1602                	slli	a2,a2,0x20
 2f6:	9201                	srli	a2,a2,0x20
 2f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fe:	0585                	addi	a1,a1,1
 300:	0705                	addi	a4,a4,1
 302:	fff5c683          	lbu	a3,-1(a1)
 306:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30a:	fef71ae3          	bne	a4,a5,2fe <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
    dst += n;
 314:	00c50733          	add	a4,a0,a2
    src += n;
 318:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31a:	fec05ae3          	blez	a2,30e <memmove+0x28>
 31e:	fff6079b          	addiw	a5,a2,-1
 322:	1782                	slli	a5,a5,0x20
 324:	9381                	srli	a5,a5,0x20
 326:	fff7c793          	not	a5,a5
 32a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 32c:	15fd                	addi	a1,a1,-1
 32e:	177d                	addi	a4,a4,-1
 330:	0005c683          	lbu	a3,0(a1)
 334:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 338:	fee79ae3          	bne	a5,a4,32c <memmove+0x46>
 33c:	bfc9                	j	30e <memmove+0x28>

000000000000033e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 344:	ca05                	beqz	a2,374 <memcmp+0x36>
 346:	fff6069b          	addiw	a3,a2,-1
 34a:	1682                	slli	a3,a3,0x20
 34c:	9281                	srli	a3,a3,0x20
 34e:	0685                	addi	a3,a3,1
 350:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 352:	00054783          	lbu	a5,0(a0)
 356:	0005c703          	lbu	a4,0(a1)
 35a:	00e79863          	bne	a5,a4,36a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 35e:	0505                	addi	a0,a0,1
    p2++;
 360:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 362:	fed518e3          	bne	a0,a3,352 <memcmp+0x14>
  }
  return 0;
 366:	4501                	li	a0,0
 368:	a019                	j	36e <memcmp+0x30>
      return *p1 - *p2;
 36a:	40e7853b          	subw	a0,a5,a4
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
  return 0;
 374:	4501                	li	a0,0
 376:	bfe5                	j	36e <memcmp+0x30>

0000000000000378 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 380:	f67ff0ef          	jal	2e6 <memmove>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38c:	4885                	li	a7,1
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exit>:
.global exit
exit:
 li a7, SYS_exit
 394:	4889                	li	a7,2
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <wait>:
.global wait
wait:
 li a7, SYS_wait
 39c:	488d                	li	a7,3
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a4:	4891                	li	a7,4
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <read>:
.global read
read:
 li a7, SYS_read
 3ac:	4895                	li	a7,5
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <write>:
.global write
write:
 li a7, SYS_write
 3b4:	48c1                	li	a7,16
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <close>:
.global close
close:
 li a7, SYS_close
 3bc:	48d5                	li	a7,21
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c4:	4899                	li	a7,6
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3cc:	489d                	li	a7,7
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <open>:
.global open
open:
 li a7, SYS_open
 3d4:	48bd                	li	a7,15
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3dc:	48c5                	li	a7,17
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e4:	48c9                	li	a7,18
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ec:	48a1                	li	a7,8
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <link>:
.global link
link:
 li a7, SYS_link
 3f4:	48cd                	li	a7,19
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fc:	48d1                	li	a7,20
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <dup>:
.global dup
dup:
 li a7, SYS_dup
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <forkwitharg>:
.global forkwitharg
forkwitharg:
 li a7, SYS_forkwitharg
 434:	48dd                	li	a7,23
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <getforkarg>:
.global getforkarg
getforkarg:
 li a7, SYS_getforkarg
 43c:	48e1                	li	a7,24
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 444:	48e5                	li	a7,25
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44c:	1101                	addi	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	1000                	addi	s0,sp,32
 454:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 458:	4605                	li	a2,1
 45a:	fef40593          	addi	a1,s0,-17
 45e:	f57ff0ef          	jal	3b4 <write>
}
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	6105                	addi	sp,sp,32
 468:	8082                	ret

000000000000046a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46a:	7139                	addi	sp,sp,-64
 46c:	fc06                	sd	ra,56(sp)
 46e:	f822                	sd	s0,48(sp)
 470:	f426                	sd	s1,40(sp)
 472:	0080                	addi	s0,sp,64
 474:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 476:	c299                	beqz	a3,47c <printint+0x12>
 478:	0805c963          	bltz	a1,50a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47c:	2581                	sext.w	a1,a1
  neg = 0;
 47e:	4881                	li	a7,0
 480:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 484:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 486:	2601                	sext.w	a2,a2
 488:	00000517          	auipc	a0,0x0
 48c:	5e850513          	addi	a0,a0,1512 # a70 <digits>
 490:	883a                	mv	a6,a4
 492:	2705                	addiw	a4,a4,1
 494:	02c5f7bb          	remuw	a5,a1,a2
 498:	1782                	slli	a5,a5,0x20
 49a:	9381                	srli	a5,a5,0x20
 49c:	97aa                	add	a5,a5,a0
 49e:	0007c783          	lbu	a5,0(a5)
 4a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a6:	0005879b          	sext.w	a5,a1
 4aa:	02c5d5bb          	divuw	a1,a1,a2
 4ae:	0685                	addi	a3,a3,1
 4b0:	fec7f0e3          	bgeu	a5,a2,490 <printint+0x26>
  if(neg)
 4b4:	00088c63          	beqz	a7,4cc <printint+0x62>
    buf[i++] = '-';
 4b8:	fd070793          	addi	a5,a4,-48
 4bc:	00878733          	add	a4,a5,s0
 4c0:	02d00793          	li	a5,45
 4c4:	fef70823          	sb	a5,-16(a4)
 4c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4cc:	02e05a63          	blez	a4,500 <printint+0x96>
 4d0:	f04a                	sd	s2,32(sp)
 4d2:	ec4e                	sd	s3,24(sp)
 4d4:	fc040793          	addi	a5,s0,-64
 4d8:	00e78933          	add	s2,a5,a4
 4dc:	fff78993          	addi	s3,a5,-1
 4e0:	99ba                	add	s3,s3,a4
 4e2:	377d                	addiw	a4,a4,-1
 4e4:	1702                	slli	a4,a4,0x20
 4e6:	9301                	srli	a4,a4,0x20
 4e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ec:	fff94583          	lbu	a1,-1(s2)
 4f0:	8526                	mv	a0,s1
 4f2:	f5bff0ef          	jal	44c <putc>
  while(--i >= 0)
 4f6:	197d                	addi	s2,s2,-1
 4f8:	ff391ae3          	bne	s2,s3,4ec <printint+0x82>
 4fc:	7902                	ld	s2,32(sp)
 4fe:	69e2                	ld	s3,24(sp)
}
 500:	70e2                	ld	ra,56(sp)
 502:	7442                	ld	s0,48(sp)
 504:	74a2                	ld	s1,40(sp)
 506:	6121                	addi	sp,sp,64
 508:	8082                	ret
    x = -xx;
 50a:	40b005bb          	negw	a1,a1
    neg = 1;
 50e:	4885                	li	a7,1
    x = -xx;
 510:	bf85                	j	480 <printint+0x16>

0000000000000512 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 512:	711d                	addi	sp,sp,-96
 514:	ec86                	sd	ra,88(sp)
 516:	e8a2                	sd	s0,80(sp)
 518:	e0ca                	sd	s2,64(sp)
 51a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51c:	0005c903          	lbu	s2,0(a1)
 520:	26090863          	beqz	s2,790 <vprintf+0x27e>
 524:	e4a6                	sd	s1,72(sp)
 526:	fc4e                	sd	s3,56(sp)
 528:	f852                	sd	s4,48(sp)
 52a:	f456                	sd	s5,40(sp)
 52c:	f05a                	sd	s6,32(sp)
 52e:	ec5e                	sd	s7,24(sp)
 530:	e862                	sd	s8,16(sp)
 532:	e466                	sd	s9,8(sp)
 534:	8b2a                	mv	s6,a0
 536:	8a2e                	mv	s4,a1
 538:	8bb2                	mv	s7,a2
  state = 0;
 53a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 53c:	4481                	li	s1,0
 53e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 540:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 544:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 548:	06c00c93          	li	s9,108
 54c:	a005                	j	56c <vprintf+0x5a>
        putc(fd, c0);
 54e:	85ca                	mv	a1,s2
 550:	855a                	mv	a0,s6
 552:	efbff0ef          	jal	44c <putc>
 556:	a019                	j	55c <vprintf+0x4a>
    } else if(state == '%'){
 558:	03598263          	beq	s3,s5,57c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 55c:	2485                	addiw	s1,s1,1
 55e:	8726                	mv	a4,s1
 560:	009a07b3          	add	a5,s4,s1
 564:	0007c903          	lbu	s2,0(a5)
 568:	20090c63          	beqz	s2,780 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 56c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 570:	fe0994e3          	bnez	s3,558 <vprintf+0x46>
      if(c0 == '%'){
 574:	fd579de3          	bne	a5,s5,54e <vprintf+0x3c>
        state = '%';
 578:	89be                	mv	s3,a5
 57a:	b7cd                	j	55c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 57c:	00ea06b3          	add	a3,s4,a4
 580:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 584:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 586:	c681                	beqz	a3,58e <vprintf+0x7c>
 588:	9752                	add	a4,a4,s4
 58a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 58e:	03878f63          	beq	a5,s8,5cc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 592:	05978963          	beq	a5,s9,5e4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 596:	07500713          	li	a4,117
 59a:	0ee78363          	beq	a5,a4,680 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 59e:	07800713          	li	a4,120
 5a2:	12e78563          	beq	a5,a4,6cc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a6:	07000713          	li	a4,112
 5aa:	14e78a63          	beq	a5,a4,6fe <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5ae:	07300713          	li	a4,115
 5b2:	18e78a63          	beq	a5,a4,746 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5b6:	02500713          	li	a4,37
 5ba:	04e79563          	bne	a5,a4,604 <vprintf+0xf2>
        putc(fd, '%');
 5be:	02500593          	li	a1,37
 5c2:	855a                	mv	a0,s6
 5c4:	e89ff0ef          	jal	44c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bf49                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5cc:	008b8913          	addi	s2,s7,8
 5d0:	4685                	li	a3,1
 5d2:	4629                	li	a2,10
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	e91ff0ef          	jal	46a <printint>
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bfad                	j	55c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5e4:	06400793          	li	a5,100
 5e8:	02f68963          	beq	a3,a5,61a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ec:	06c00793          	li	a5,108
 5f0:	04f68263          	beq	a3,a5,634 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5f4:	07500793          	li	a5,117
 5f8:	0af68063          	beq	a3,a5,698 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5fc:	07800793          	li	a5,120
 600:	0ef68263          	beq	a3,a5,6e4 <vprintf+0x1d2>
        putc(fd, '%');
 604:	02500593          	li	a1,37
 608:	855a                	mv	a0,s6
 60a:	e43ff0ef          	jal	44c <putc>
        putc(fd, c0);
 60e:	85ca                	mv	a1,s2
 610:	855a                	mv	a0,s6
 612:	e3bff0ef          	jal	44c <putc>
      state = 0;
 616:	4981                	li	s3,0
 618:	b791                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e43ff0ef          	jal	46a <printint>
        i += 1;
 62c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
        i += 1;
 632:	b72d                	j	55c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 634:	06400793          	li	a5,100
 638:	02f60763          	beq	a2,a5,666 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 63c:	07500793          	li	a5,117
 640:	06f60963          	beq	a2,a5,6b2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 644:	07800793          	li	a5,120
 648:	faf61ee3          	bne	a2,a5,604 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8913          	addi	s2,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000ba583          	lw	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	e11ff0ef          	jal	46a <printint>
        i += 2;
 65e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 2;
 664:	bde5                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 666:	008b8913          	addi	s2,s7,8
 66a:	4685                	li	a3,1
 66c:	4629                	li	a2,10
 66e:	000ba583          	lw	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	df7ff0ef          	jal	46a <printint>
        i += 2;
 678:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
        i += 2;
 67e:	bdf9                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 680:	008b8913          	addi	s2,s7,8
 684:	4681                	li	a3,0
 686:	4629                	li	a2,10
 688:	000ba583          	lw	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	dddff0ef          	jal	46a <printint>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	b5d9                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	dc5ff0ef          	jal	46a <printint>
        i += 1;
 6aa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
        i += 1;
 6b0:	b575                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4629                	li	a2,10
 6ba:	000ba583          	lw	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	dabff0ef          	jal	46a <printint>
        i += 2;
 6c4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
        i += 2;
 6ca:	bd49                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6cc:	008b8913          	addi	s2,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4641                	li	a2,16
 6d4:	000ba583          	lw	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	d91ff0ef          	jal	46a <printint>
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bdad                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4641                	li	a2,16
 6ec:	000ba583          	lw	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	d79ff0ef          	jal	46a <printint>
        i += 1;
 6f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
        i += 1;
 6fc:	b585                	j	55c <vprintf+0x4a>
 6fe:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 700:	008b8d13          	addi	s10,s7,8
 704:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 708:	03000593          	li	a1,48
 70c:	855a                	mv	a0,s6
 70e:	d3fff0ef          	jal	44c <putc>
  putc(fd, 'x');
 712:	07800593          	li	a1,120
 716:	855a                	mv	a0,s6
 718:	d35ff0ef          	jal	44c <putc>
 71c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71e:	00000b97          	auipc	s7,0x0
 722:	352b8b93          	addi	s7,s7,850 # a70 <digits>
 726:	03c9d793          	srli	a5,s3,0x3c
 72a:	97de                	add	a5,a5,s7
 72c:	0007c583          	lbu	a1,0(a5)
 730:	855a                	mv	a0,s6
 732:	d1bff0ef          	jal	44c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 736:	0992                	slli	s3,s3,0x4
 738:	397d                	addiw	s2,s2,-1
 73a:	fe0916e3          	bnez	s2,726 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 73e:	8bea                	mv	s7,s10
      state = 0;
 740:	4981                	li	s3,0
 742:	6d02                	ld	s10,0(sp)
 744:	bd21                	j	55c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 746:	008b8993          	addi	s3,s7,8
 74a:	000bb903          	ld	s2,0(s7)
 74e:	00090f63          	beqz	s2,76c <vprintf+0x25a>
        for(; *s; s++)
 752:	00094583          	lbu	a1,0(s2)
 756:	c195                	beqz	a1,77a <vprintf+0x268>
          putc(fd, *s);
 758:	855a                	mv	a0,s6
 75a:	cf3ff0ef          	jal	44c <putc>
        for(; *s; s++)
 75e:	0905                	addi	s2,s2,1
 760:	00094583          	lbu	a1,0(s2)
 764:	f9f5                	bnez	a1,758 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 766:	8bce                	mv	s7,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	bbcd                	j	55c <vprintf+0x4a>
          s = "(null)";
 76c:	00000917          	auipc	s2,0x0
 770:	2fc90913          	addi	s2,s2,764 # a68 <malloc+0x1f0>
        for(; *s; s++)
 774:	02800593          	li	a1,40
 778:	b7c5                	j	758 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 77a:	8bce                	mv	s7,s3
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bbf9                	j	55c <vprintf+0x4a>
 780:	64a6                	ld	s1,72(sp)
 782:	79e2                	ld	s3,56(sp)
 784:	7a42                	ld	s4,48(sp)
 786:	7aa2                	ld	s5,40(sp)
 788:	7b02                	ld	s6,32(sp)
 78a:	6be2                	ld	s7,24(sp)
 78c:	6c42                	ld	s8,16(sp)
 78e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 790:	60e6                	ld	ra,88(sp)
 792:	6446                	ld	s0,80(sp)
 794:	6906                	ld	s2,64(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79a:	715d                	addi	sp,sp,-80
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e010                	sd	a2,0(s0)
 7a4:	e414                	sd	a3,8(s0)
 7a6:	e818                	sd	a4,16(s0)
 7a8:	ec1c                	sd	a5,24(s0)
 7aa:	03043023          	sd	a6,32(s0)
 7ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b6:	8622                	mv	a2,s0
 7b8:	d5bff0ef          	jal	512 <vprintf>
}
 7bc:	60e2                	ld	ra,24(sp)
 7be:	6442                	ld	s0,16(sp)
 7c0:	6161                	addi	sp,sp,80
 7c2:	8082                	ret

00000000000007c4 <printf>:

void
printf(const char *fmt, ...)
{
 7c4:	711d                	addi	sp,sp,-96
 7c6:	ec06                	sd	ra,24(sp)
 7c8:	e822                	sd	s0,16(sp)
 7ca:	1000                	addi	s0,sp,32
 7cc:	e40c                	sd	a1,8(s0)
 7ce:	e810                	sd	a2,16(s0)
 7d0:	ec14                	sd	a3,24(s0)
 7d2:	f018                	sd	a4,32(s0)
 7d4:	f41c                	sd	a5,40(s0)
 7d6:	03043823          	sd	a6,48(s0)
 7da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7de:	00840613          	addi	a2,s0,8
 7e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e6:	85aa                	mv	a1,a0
 7e8:	4505                	li	a0,1
 7ea:	d29ff0ef          	jal	512 <vprintf>
}
 7ee:	60e2                	ld	ra,24(sp)
 7f0:	6442                	ld	s0,16(sp)
 7f2:	6125                	addi	sp,sp,96
 7f4:	8082                	ret

00000000000007f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f6:	1141                	addi	sp,sp,-16
 7f8:	e422                	sd	s0,8(sp)
 7fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 800:	00001797          	auipc	a5,0x1
 804:	8007b783          	ld	a5,-2048(a5) # 1000 <freep>
 808:	a02d                	j	832 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80a:	4618                	lw	a4,8(a2)
 80c:	9f2d                	addw	a4,a4,a1
 80e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	6398                	ld	a4,0(a5)
 814:	6310                	ld	a2,0(a4)
 816:	a83d                	j	854 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 818:	ff852703          	lw	a4,-8(a0)
 81c:	9f31                	addw	a4,a4,a2
 81e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 820:	ff053683          	ld	a3,-16(a0)
 824:	a091                	j	868 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	6398                	ld	a4,0(a5)
 828:	00e7e463          	bltu	a5,a4,830 <free+0x3a>
 82c:	00e6ea63          	bltu	a3,a4,840 <free+0x4a>
{
 830:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	fed7fae3          	bgeu	a5,a3,826 <free+0x30>
 836:	6398                	ld	a4,0(a5)
 838:	00e6e463          	bltu	a3,a4,840 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	fee7eae3          	bltu	a5,a4,830 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 840:	ff852583          	lw	a1,-8(a0)
 844:	6390                	ld	a2,0(a5)
 846:	02059813          	slli	a6,a1,0x20
 84a:	01c85713          	srli	a4,a6,0x1c
 84e:	9736                	add	a4,a4,a3
 850:	fae60de3          	beq	a2,a4,80a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 858:	4790                	lw	a2,8(a5)
 85a:	02061593          	slli	a1,a2,0x20
 85e:	01c5d713          	srli	a4,a1,0x1c
 862:	973e                	add	a4,a4,a5
 864:	fae68ae3          	beq	a3,a4,818 <free+0x22>
    p->s.ptr = bp->s.ptr;
 868:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86a:	00000717          	auipc	a4,0x0
 86e:	78f73b23          	sd	a5,1942(a4) # 1000 <freep>
}
 872:	6422                	ld	s0,8(sp)
 874:	0141                	addi	sp,sp,16
 876:	8082                	ret

0000000000000878 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 878:	7139                	addi	sp,sp,-64
 87a:	fc06                	sd	ra,56(sp)
 87c:	f822                	sd	s0,48(sp)
 87e:	f426                	sd	s1,40(sp)
 880:	ec4e                	sd	s3,24(sp)
 882:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 884:	02051493          	slli	s1,a0,0x20
 888:	9081                	srli	s1,s1,0x20
 88a:	04bd                	addi	s1,s1,15
 88c:	8091                	srli	s1,s1,0x4
 88e:	0014899b          	addiw	s3,s1,1
 892:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 894:	00000517          	auipc	a0,0x0
 898:	76c53503          	ld	a0,1900(a0) # 1000 <freep>
 89c:	c915                	beqz	a0,8d0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	08977a63          	bgeu	a4,s1,936 <malloc+0xbe>
 8a6:	f04a                	sd	s2,32(sp)
 8a8:	e852                	sd	s4,16(sp)
 8aa:	e456                	sd	s5,8(sp)
 8ac:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ae:	8a4e                	mv	s4,s3
 8b0:	0009871b          	sext.w	a4,s3
 8b4:	6685                	lui	a3,0x1
 8b6:	00d77363          	bgeu	a4,a3,8bc <malloc+0x44>
 8ba:	6a05                	lui	s4,0x1
 8bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c4:	00000917          	auipc	s2,0x0
 8c8:	73c90913          	addi	s2,s2,1852 # 1000 <freep>
  if(p == (char*)-1)
 8cc:	5afd                	li	s5,-1
 8ce:	a081                	j	90e <malloc+0x96>
 8d0:	f04a                	sd	s2,32(sp)
 8d2:	e852                	sd	s4,16(sp)
 8d4:	e456                	sd	s5,8(sp)
 8d6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d8:	00000797          	auipc	a5,0x0
 8dc:	73878793          	addi	a5,a5,1848 # 1010 <base>
 8e0:	00000717          	auipc	a4,0x0
 8e4:	72f73023          	sd	a5,1824(a4) # 1000 <freep>
 8e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ee:	b7c1                	j	8ae <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8f0:	6398                	ld	a4,0(a5)
 8f2:	e118                	sd	a4,0(a0)
 8f4:	a8a9                	j	94e <malloc+0xd6>
  hp->s.size = nu;
 8f6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fa:	0541                	addi	a0,a0,16
 8fc:	efbff0ef          	jal	7f6 <free>
  return freep;
 900:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 904:	c12d                	beqz	a0,966 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 908:	4798                	lw	a4,8(a5)
 90a:	02977263          	bgeu	a4,s1,92e <malloc+0xb6>
    if(p == freep)
 90e:	00093703          	ld	a4,0(s2)
 912:	853e                	mv	a0,a5
 914:	fef719e3          	bne	a4,a5,906 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 918:	8552                	mv	a0,s4
 91a:	b03ff0ef          	jal	41c <sbrk>
  if(p == (char*)-1)
 91e:	fd551ce3          	bne	a0,s5,8f6 <malloc+0x7e>
        return 0;
 922:	4501                	li	a0,0
 924:	7902                	ld	s2,32(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
 92c:	a03d                	j	95a <malloc+0xe2>
 92e:	7902                	ld	s2,32(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 936:	fae48de3          	beq	s1,a4,8f0 <malloc+0x78>
        p->s.size -= nunits;
 93a:	4137073b          	subw	a4,a4,s3
 93e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 940:	02071693          	slli	a3,a4,0x20
 944:	01c6d713          	srli	a4,a3,0x1c
 948:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94e:	00000717          	auipc	a4,0x0
 952:	6aa73923          	sd	a0,1714(a4) # 1000 <freep>
      return (void*)(p + 1);
 956:	01078513          	addi	a0,a5,16
  }
}
 95a:	70e2                	ld	ra,56(sp)
 95c:	7442                	ld	s0,48(sp)
 95e:	74a2                	ld	s1,40(sp)
 960:	69e2                	ld	s3,24(sp)
 962:	6121                	addi	sp,sp,64
 964:	8082                	ret
 966:	7902                	ld	s2,32(sp)
 968:	6a42                	ld	s4,16(sp)
 96a:	6aa2                	ld	s5,8(sp)
 96c:	6b02                	ld	s6,0(sp)
 96e:	b7f5                	j	95a <malloc+0xe2>
