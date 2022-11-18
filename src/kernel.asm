
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 c5 10 80       	mov    $0x8010c5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 80 10 80       	push   $0x801080c0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 45 52 00 00       	call   801052a0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 80 10 80       	push   $0x801080c7
80100097:	50                   	push   %eax
80100098:	e8 d3 50 00 00       	call   80105170 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 f7 52 00 00       	call   801053e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 39 53 00 00       	call   801054a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 50 00 00       	call   801051b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 80 10 80       	push   $0x801080ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 9d 50 00 00       	call   80105250 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 80 10 80       	push   $0x801080df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 5c 50 00 00       	call   80105250 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 50 00 00       	call   80105210 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 d0 51 00 00       	call   801053e0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 3f 52 00 00       	jmp    801054a0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 80 10 80       	push   $0x801080e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010028c:	e8 4f 51 00 00       	call   801053e0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 0f 11 80    	mov    0x80110fe0,%edx
801002a7:	39 15 e4 0f 11 80    	cmp    %edx,0x80110fe4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 40 b5 10 80       	push   $0x8010b540
801002c0:	68 e0 0f 11 80       	push   $0x80110fe0
801002c5:	e8 06 4a 00 00       	call   80104cd0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 0f 11 80    	mov    0x80110fe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 0f 11 80    	cmp    0x80110fe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 80 35 00 00       	call   80103860 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 40 b5 10 80       	push   $0x8010b540
801002ef:	e8 ac 51 00 00       	call   801054a0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 e0 0f 11 80       	mov    %eax,0x80110fe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 0f 11 80 	movsbl -0x7feef0a0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 40 b5 10 80       	push   $0x8010b540
8010034d:	e8 4e 51 00 00       	call   801054a0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 e0 0f 11 80    	mov    %edx,0x80110fe0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 80 10 80       	push   $0x801080ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 67 8b 10 80 	movl   $0x80108b67,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 e3 4e 00 00       	call   801052c0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 81 10 80       	push   $0x80108101
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 68 00 00       	call   80106cc0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 67 00 00       	call   80106cc0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 67 00 00       	call   80106cc0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 67 00 00       	call   80106cc0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 77 50 00 00       	call   801055a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 aa 4f 00 00       	call   801054f0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 81 10 80       	push   $0x80108105
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 81 10 80 	movzbl -0x7fef7ed0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010061b:	e8 c0 4d 00 00       	call   801053e0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 40 b5 10 80       	push   $0x8010b540
80100647:	e8 54 4e 00 00       	call   801054a0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 74 b5 10 80       	mov    0x8010b574,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 40 b5 10 80       	push   $0x8010b540
8010071f:	e8 7c 4d 00 00       	call   801054a0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 81 10 80       	mov    $0x80108118,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 40 b5 10 80       	push   $0x8010b540
801007f0:	e8 eb 4b 00 00       	call   801053e0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 81 10 80       	push   $0x8010811f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 40 b5 10 80       	push   $0x8010b540
80100823:	e8 b8 4b 00 00       	call   801053e0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100856:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 40 b5 10 80       	push   $0x8010b540
80100888:	e8 13 4c 00 00       	call   801054a0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 0f 11 80    	sub    0x80110fe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 0f 11 80    	mov    %edx,0x80110fe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 0f 11 80    	mov    %cl,-0x7feef0a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 0f 11 80    	cmp    %eax,0x80110fe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 0f 11 80       	mov    %eax,0x80110fe4
          wakeup(&input.r);
80100911:	68 e0 0f 11 80       	push   $0x80110fe0
80100916:	e8 a5 46 00 00       	call   80104fc0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
8010093d:	39 05 e4 0f 11 80    	cmp    %eax,0x80110fe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100964:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 04 47 00 00       	jmp    801050a0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 0f 11 80 0a 	movb   $0xa,-0x7feef0a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 81 10 80       	push   $0x80108128
801009cb:	68 40 b5 10 80       	push   $0x8010b540
801009d0:	e8 cb 48 00 00       	call   801052a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac 19 11 80 00 	movl   $0x80100600,0x801119ac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 19 11 80 70 	movl   $0x80100270,0x801119a8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 3f 2e 00 00       	call   80103860 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 77 73 00 00       	call   80107e10 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 35 71 00 00       	call   80107c30 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 43 70 00 00       	call   80107b70 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 19 72 00 00       	call   80107d90 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 81 70 00 00       	call   80107c30 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ca 71 00 00       	call   80107d90 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 81 10 80       	push   $0x80108141
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 a5 72 00 00       	call   80107eb0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 d2 4a 00 00       	call   80105710 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 bf 4a 00 00       	call   80105710 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ae 73 00 00       	call   80108010 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 44 73 00 00       	call   80108010 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 c1 49 00 00       	call   801056d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 a7 6c 00 00       	call   801079e0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 4f 70 00 00       	call   80107d90 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 81 10 80       	push   $0x8010814d
80100d6b:	68 00 10 11 80       	push   $0x80111000
80100d70:	e8 2b 45 00 00       	call   801052a0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 34 10 11 80       	mov    $0x80111034,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 00 10 11 80       	push   $0x80111000
80100d91:	e8 4a 46 00 00       	call   801053e0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 94 19 11 80    	cmp    $0x80111994,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 00 10 11 80       	push   $0x80111000
80100dc1:	e8 da 46 00 00       	call   801054a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 00 10 11 80       	push   $0x80111000
80100dda:	e8 c1 46 00 00       	call   801054a0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 00 10 11 80       	push   $0x80111000
80100dff:	e8 dc 45 00 00       	call   801053e0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 00 10 11 80       	push   $0x80111000
80100e1c:	e8 7f 46 00 00       	call   801054a0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 81 10 80       	push   $0x80108154
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 00 10 11 80       	push   $0x80111000
80100e51:	e8 8a 45 00 00       	call   801053e0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 00 10 11 80 	movl   $0x80111000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 1f 46 00 00       	jmp    801054a0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 00 10 11 80       	push   $0x80111000
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 f3 45 00 00       	call   801054a0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 81 10 80       	push   $0x8010815c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 81 10 80       	push   $0x80108166
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 81 10 80       	push   $0x8010816f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 81 10 80       	push   $0x80108175
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 18 1a 11 80    	add    0x80111a18,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 7f 81 10 80       	push   $0x8010817f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d 00 1a 11 80    	mov    0x80111a00,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 18 1a 11 80    	add    0x80111a18,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 00 1a 11 80       	mov    0x80111a00,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 00 1a 11 80    	cmp    %eax,0x80111a00
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 92 81 10 80       	push   $0x80108192
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 86 42 00 00       	call   801054f0 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 54 1a 11 80       	mov    $0x80111a54,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 20 1a 11 80       	push   $0x80111a20
801012aa:	e8 31 41 00 00       	call   801053e0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 20 1a 11 80       	push   $0x80111a20
8010130f:	e8 8c 41 00 00       	call   801054a0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 20 1a 11 80       	push   $0x80111a20
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 5e 41 00 00       	call   801054a0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 a8 81 10 80       	push   $0x801081a8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 b8 81 10 80       	push   $0x801081b8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 3a 41 00 00       	call   801055a0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 60 1a 11 80       	mov    $0x80111a60,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 cb 81 10 80       	push   $0x801081cb
80101491:	68 20 1a 11 80       	push   $0x80111a20
80101496:	e8 05 3e 00 00       	call   801052a0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 81 10 80       	push   $0x801081d2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 bc 3c 00 00       	call   80105170 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 80 36 11 80    	cmp    $0x80113680,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 00 1a 11 80       	push   $0x80111a00
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 18 1a 11 80    	pushl  0x80111a18
801014d5:	ff 35 14 1a 11 80    	pushl  0x80111a14
801014db:	ff 35 10 1a 11 80    	pushl  0x80111a10
801014e1:	ff 35 0c 1a 11 80    	pushl  0x80111a0c
801014e7:	ff 35 08 1a 11 80    	pushl  0x80111a08
801014ed:	ff 35 04 1a 11 80    	pushl  0x80111a04
801014f3:	ff 35 00 1a 11 80    	pushl  0x80111a00
801014f9:	68 38 82 10 80       	push   $0x80108238
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d 08 1a 11 80 01 	cmpl   $0x1,0x80111a08
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d 08 1a 11 80    	cmp    %ebx,0x80111a08
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 14 1a 11 80    	add    0x80111a14,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 5d 3f 00 00       	call   801054f0 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 d8 81 10 80       	push   $0x801081d8
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 14 1a 11 80    	add    0x80111a14,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 6a 3f 00 00       	call   801055a0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 20 1a 11 80       	push   $0x80111a20
8010165f:	e8 7c 3d 00 00       	call   801053e0 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
8010166f:	e8 2c 3e 00 00       	call   801054a0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 09 3b 00 00       	call   801051b0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 14 1a 11 80    	add    0x80111a14,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 83 3e 00 00       	call   801055a0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 f0 81 10 80       	push   $0x801081f0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 81 10 80       	push   $0x801081ea
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 d8 3a 00 00       	call   80105250 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 7c 3a 00 00       	jmp    80105210 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 81 10 80       	push   $0x801081ff
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 eb 39 00 00       	call   801051b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 31 3a 00 00       	call   80105210 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
801017e6:	e8 f5 3b 00 00       	call   801053e0 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 20 1a 11 80 	movl   $0x80111a20,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 9b 3c 00 00       	jmp    801054a0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 20 1a 11 80       	push   $0x80111a20
80101810:	e8 cb 3b 00 00       	call   801053e0 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
8010181f:	e8 7c 3c 00 00       	call   801054a0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 94 3b 00 00       	call   801055a0 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 a0 19 11 80 	mov    -0x7feee660(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 98 3a 00 00       	call   801055a0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 a4 19 11 80 	mov    -0x7feee65c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 6d 3a 00 00       	call   80105610 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 0e 3a 00 00       	call   80105610 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 19 82 10 80       	push   $0x80108219
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 82 10 80       	push   $0x80108207
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 e2 1b 00 00       	call   80103860 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 20 1a 11 80       	push   $0x80111a20
80101c89:	e8 52 37 00 00       	call   801053e0 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101c99:	e8 02 38 00 00       	call   801054a0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 a6 38 00 00       	call   801055a0 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 13 38 00 00       	call   801055a0 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 ee 37 00 00       	call   80105670 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 28 82 10 80       	push   $0x80108228
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 4e 89 10 80       	push   $0x8010894e
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 94 82 10 80       	push   $0x80108294
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 8b 82 10 80       	push   $0x8010828b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 a6 82 10 80       	push   $0x801082a6
8010200b:	68 a0 b5 10 80       	push   $0x8010b5a0
80102010:	e8 8b 32 00 00       	call   801052a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 20 39 11 80       	mov    0x80113920,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 a0 b5 10 80       	push   $0x8010b5a0
8010208e:	e8 4d 33 00 00       	call   801053e0 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 ca 2e 00 00       	call   80104fc0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 84 b5 10 80       	mov    0x8010b584,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 a0 b5 10 80       	push   $0x8010b5a0
8010210f:	e8 8c 33 00 00       	call   801054a0 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 1d 31 00 00       	call   80105250 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 a0 b5 10 80       	push   $0x8010b5a0
80102168:	e8 73 32 00 00       	call   801053e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 a0 b5 10 80       	push   $0x8010b5a0
801021b8:	53                   	push   %ebx
801021b9:	e8 12 2b 00 00       	call   80104cd0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 c5 32 00 00       	jmp    801054a0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 c0 82 10 80       	push   $0x801082c0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 aa 82 10 80       	push   $0x801082aa
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 d5 82 10 80       	push   $0x801082d5
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 74 36 11 80 00 	movl   $0xfec00000,0x80113674
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 74 36 11 80       	mov    0x80113674,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 f4 82 10 80       	push   $0x801082f4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 74 36 11 80       	mov    0x80113674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb c8 72 11 80    	cmp    $0x801172c8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 a9 31 00 00       	call   801054f0 <memset>

  if(kmem.use_lock)
80102347:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 b4 36 11 80       	mov    0x801136b4,%eax
  kmem.freelist = r;
80102360:	89 1d b8 36 11 80    	mov    %ebx,0x801136b8
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 20 31 00 00       	jmp    801054a0 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 80 36 11 80       	push   $0x80113680
80102388:	e8 53 30 00 00       	call   801053e0 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 26 83 10 80       	push   $0x80108326
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 2c 83 10 80       	push   $0x8010832c
80102400:	68 80 36 11 80       	push   $0x80113680
80102405:	e8 96 2e 00 00       	call   801052a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 b4 36 11 80 00 	movl   $0x0,0x801136b4
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 b4 36 11 80 01 	movl   $0x1,0x801136b4
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 80 36 11 80       	push   $0x80113680
801024f3:	e8 e8 2e 00 00       	call   801053e0 <acquire>
  r = kmem.freelist;
801024f8:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d b8 36 11 80    	mov    %ecx,0x801136b8
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 80 36 11 80       	push   $0x80113680
80102521:	e8 7a 2f 00 00       	call   801054a0 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d d4 b5 10 80    	mov    0x8010b5d4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 60 84 10 80 	movzbl -0x7fef7ba0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 60 83 10 80 	movzbl -0x7fef7ca0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 40 83 10 80 	mov    -0x7fef7cc0(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 60 84 10 80 	movzbl -0x7fef7ba0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 bc 36 11 80       	mov    0x801136bc,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 bc 36 11 80    	mov    0x801136bc,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 bc 36 11 80       	mov    0x801136bc,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 04 2c 00 00       	call   80105540 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 04 37 11 80    	pushl  0x80113704
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 0c 37 11 80 	pushl  -0x7feec8f4(,%ebx,4)
80102a44:	ff 35 04 37 11 80    	pushl  0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 37 2b 00 00       	call   801055a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d 08 37 11 80    	cmp    %ebx,0x80113708
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 f4 36 11 80    	pushl  0x801136f4
80102aae:	ff 35 04 37 11 80    	pushl  0x80113704
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d 08 37 11 80    	mov    0x80113708,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a 0c 37 11 80    	mov    -0x7feec8f4(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 60 85 10 80       	push   $0x80108560
80102b0f:	68 c0 36 11 80       	push   $0x801136c0
80102b14:	e8 87 27 00 00       	call   801052a0 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102b32:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  log.start = sb.logstart;
80102b38:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 08 37 11 80    	mov    %ecx,-0x7feec8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 c0 36 11 80       	push   $0x801136c0
80102bab:	e8 30 28 00 00       	call   801053e0 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 c0 36 11 80       	push   $0x801136c0
80102bc0:	68 c0 36 11 80       	push   $0x801136c0
80102bc5:	e8 06 21 00 00       	call   80104cd0 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 00 37 11 80       	mov    0x80113700,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102bdb:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102bf7:	68 c0 36 11 80       	push   $0x801136c0
80102bfc:	e8 9f 28 00 00       	call   801054a0 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 c0 36 11 80       	push   $0x801136c0
80102c1e:	e8 bd 27 00 00       	call   801053e0 <acquire>
  log.outstanding -= 1;
80102c23:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102c28:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 c0 36 11 80       	push   $0x801136c0
80102c5c:	e8 3f 28 00 00       	call   801054a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 04 37 11 80    	pushl  0x80113704
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 0c 37 11 80 	pushl  -0x7feec8f4(,%ebx,4)
80102c96:	ff 35 04 37 11 80    	pushl  0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 e5 28 00 00       	call   801055a0 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 c0 36 11 80       	push   $0x801136c0
80102cff:	e8 dc 26 00 00       	call   801053e0 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 a6 22 00 00       	call   80104fc0 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102d21:	e8 7a 27 00 00       	call   801054a0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 c0 36 11 80       	push   $0x801136c0
80102d40:	e8 7b 22 00 00       	call   80104fc0 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102d4c:	e8 4f 27 00 00       	call   801054a0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 64 85 10 80       	push   $0x80108564
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 c0 36 11 80       	push   $0x801136c0
80102dae:	e8 2d 26 00 00       	call   801053e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 0c 37 11 80    	cmp    0x8011370c,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 0c 37 11 80 	cmp    %edx,-0x7feec8f4(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 0c 37 11 80 	mov    %edx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 08 37 11 80       	mov    %eax,0x80113708
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 9e 26 00 00       	jmp    801054a0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 0c 37 11 80 	mov    %edx,-0x7feec8f4(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 0c 37 11 80       	mov    %eax,0x8011370c
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 73 85 10 80       	push   $0x80108573
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 89 85 10 80       	push   $0x80108589
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 f4 09 00 00       	call   80103840 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 ed 09 00 00       	call   80103840 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 a4 85 10 80       	push   $0x801085a4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 09 3a 00 00       	call   80106870 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 64 09 00 00       	call   801037d0 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 51 0f 00 00       	call   80103dd0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 35 4b 00 00       	call   801079c0 <switchkvm>
  seginit();
80102e8b:	e8 a0 4a 00 00       	call   80107930 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 c8 72 11 80       	push   $0x801172c8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 ca 4f 00 00       	call   80107e90 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 5b 4a 00 00       	call   80107930 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 17 3d 00 00       	call   80106c00 <uartinit>
  pinit();         // process table
80102ee9:	e8 c2 08 00 00       	call   801037b0 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 fd 38 00 00       	call   801067f0 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 ac b4 10 80       	push   $0x8010b4ac
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 87 26 00 00       	call   801055a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 20 39 11 80 b0 	imul   $0xb0,0x80113920,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 c0 37 11 80       	add    $0x801137c0,%eax
80102f2b:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 8b 08 00 00       	call   801037d0 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 20 39 11 80 b0 	imul   $0xb0,0x80113920,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 c0 37 11 80       	add    $0x801137c0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 d6 08 00 00       	call   80103890 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 b8 85 10 80       	push   $0x801085b8
80102ff3:	56                   	push   %esi
80102ff4:	e8 47 25 00 00       	call   80105540 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 d5 85 10 80       	push   $0x801085d5
801030b1:	56                   	push   %esi
801030b2:	e8 89 24 00 00       	call   80105540 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 fc 85 10 80 	jmp    *-0x7fef7a04(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 20 39 11 80    	mov    0x80113920,%ecx
8010318e:	83 f9 01             	cmp    $0x1,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 20 39 11 80    	mov    %ecx,0x80113920
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 c0 37 11 80    	mov    %dl,-0x7feec840(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 a0 37 11 80    	mov    %dl,0x801137a0
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 bd 85 10 80       	push   $0x801085bd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 dc 85 10 80       	push   $0x801085dc
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 10 86 10 80       	push   $0x80108610
80103300:	50                   	push   %eax
80103301:	e8 9a 1f 00 00       	call   801052a0 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 7c 20 00 00       	call   801053e0 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 3c 1c 00 00       	call   80104fc0 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 f7 20 00 00       	jmp    801054a0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 f7 1b 00 00       	call   80104fc0 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 c7 20 00 00       	call   801054a0 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 de 1f 00 00       	call   801053e0 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 67 1b 00 00       	call   80104fc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 6e 18 00 00       	call   80104cd0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 d7 03 00 00       	call   80103860 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 07 20 00 00       	call   801054a0 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 d8 1a 00 00       	call   80104fc0 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 b0 1f 00 00       	call   801054a0 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 cb 1e 00 00       	call   801053e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 86 17 00 00       	call   80104cd0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 f2 02 00 00       	call   80103860 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 1d 1f 00 00       	call   801054a0 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 e4 19 00 00       	call   80104fc0 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 bc 1e 00 00       	call   801054a0 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103604:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103609:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010360c:	68 40 3d 11 80       	push   $0x80113d40
80103611:	e8 ca 1d 00 00       	call   801053e0 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103626:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
8010362c:	0f 83 fe 00 00 00    	jae    80103730 <allocproc+0x130>
    if(p->state == UNUSED)
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103639:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->current_queue = 0; // used for mlfq
  p->ticks[0] = p->ticks[1] = p->ticks[2] = p->ticks[3] = p->ticks[4] = 0;
  p->lastexperiencedtick=0;
  c0++;
  q0[c0] = p;
  release(&ptable.lock);
8010363e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103641:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority=60;	// used for pbs
80103648:	c7 83 a8 00 00 00 3c 	movl   $0x3c,0xa8(%ebx)
8010364f:	00 00 00 
  p->current_queue = 0; // used for mlfq
80103652:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80103659:	00 00 00 
  p->ticks[0] = p->ticks[1] = p->ticks[2] = p->ticks[3] = p->ticks[4] = 0;
8010365c:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80103663:	00 00 00 
80103666:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010366d:	00 00 00 
  p->pid = nextpid++;
80103670:	8d 50 01             	lea    0x1(%eax),%edx
80103673:	89 43 10             	mov    %eax,0x10(%ebx)
  c0++;
80103676:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
  p->ticks[0] = p->ticks[1] = p->ticks[2] = p->ticks[3] = p->ticks[4] = 0;
8010367b:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103682:	00 00 00 
80103685:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010368c:	00 00 00 
8010368f:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103696:	00 00 00 
  p->lastexperiencedtick=0;
80103699:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801036a0:	00 00 00 
  release(&ptable.lock);
801036a3:	68 40 3d 11 80       	push   $0x80113d40
  c0++;
801036a8:	83 c0 01             	add    $0x1,%eax
  p->pid = nextpid++;
801036ab:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  c0++;
801036b1:	a3 2c b0 10 80       	mov    %eax,0x8010b02c
  q0[c0] = p;
801036b6:	89 1c 85 40 3c 11 80 	mov    %ebx,-0x7feec3c0(,%eax,4)
  release(&ptable.lock);
801036bd:	e8 de 1d 00 00       	call   801054a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036c2:	e8 f9 ed ff ff       	call   801024c0 <kalloc>
801036c7:	83 c4 10             	add    $0x10,%esp
801036ca:	85 c0                	test   %eax,%eax
801036cc:	89 43 08             	mov    %eax,0x8(%ebx)
801036cf:	74 78                	je     80103749 <allocproc+0x149>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036d1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036d7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036da:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036df:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036e2:	c7 40 14 e2 67 10 80 	movl   $0x801067e2,0x14(%eax)
  p->context = (struct context*)sp;
801036e9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036ec:	6a 14                	push   $0x14
801036ee:	6a 00                	push   $0x0
801036f0:	50                   	push   %eax
801036f1:	e8 fa 1d 00 00       	call   801054f0 <memset>
  p->context->eip = (uint)forkret;
801036f6:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->stime = ticks;         // start time
  p->etime = 0;             // end time
  p->rtime = 0;             // run time
  p->iotime = 0;            // I/O time
  
  return p;
801036f9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036fc:	c7 40 10 60 37 10 80 	movl   $0x80103760,0x10(%eax)
  p->stime = ticks;         // start time
80103703:	a1 c0 72 11 80       	mov    0x801172c0,%eax
  p->etime = 0;             // end time
80103708:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010370f:	00 00 00 
  p->rtime = 0;             // run time
80103712:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103719:	00 00 00 
  p->iotime = 0;            // I/O time
8010371c:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103723:	00 00 00 
  p->stime = ticks;         // start time
80103726:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
80103729:	89 d8                	mov    %ebx,%eax
8010372b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010372e:	c9                   	leave  
8010372f:	c3                   	ret    
  release(&ptable.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103733:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103735:	68 40 3d 11 80       	push   $0x80113d40
8010373a:	e8 61 1d 00 00       	call   801054a0 <release>
}
8010373f:	89 d8                	mov    %ebx,%eax
  return 0;
80103741:	83 c4 10             	add    $0x10,%esp
}
80103744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103747:	c9                   	leave  
80103748:	c3                   	ret    
    p->state = UNUSED;
80103749:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103750:	31 db                	xor    %ebx,%ebx
80103752:	eb d5                	jmp    80103729 <allocproc+0x129>
80103754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010375a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103760 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103766:	68 40 3d 11 80       	push   $0x80113d40
8010376b:	e8 30 1d 00 00       	call   801054a0 <release>

  if (first) {
80103770:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 c0                	test   %eax,%eax
8010377a:	75 04                	jne    80103780 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010377c:	c9                   	leave  
8010377d:	c3                   	ret    
8010377e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103780:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103783:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010378a:	00 00 00 
    iinit(ROOTDEV);
8010378d:	6a 01                	push   $0x1
8010378f:	e8 ec dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103794:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010379b:	e8 60 f3 ff ff       	call   80102b00 <initlog>
801037a0:	83 c4 10             	add    $0x10,%esp
}
801037a3:	c9                   	leave  
801037a4:	c3                   	ret    
801037a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037b0 <pinit>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037b6:	68 15 86 10 80       	push   $0x80108615
801037bb:	68 40 3d 11 80       	push   $0x80113d40
801037c0:	e8 db 1a 00 00       	call   801052a0 <initlock>
}
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	c9                   	leave  
801037c9:	c3                   	ret    
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037d0 <mycpu>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037d6:	9c                   	pushf  
801037d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037d8:	f6 c4 02             	test   $0x2,%ah
801037db:	75 4a                	jne    80103827 <mycpu+0x57>
  apicid = lapicid();
801037dd:	e8 4e ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037e2:	8b 15 20 39 11 80    	mov    0x80113920,%edx
801037e8:	85 d2                	test   %edx,%edx
801037ea:	7e 1b                	jle    80103807 <mycpu+0x37>
    if (cpus[i].apicid == apicid)
801037ec:	0f b6 0d c0 37 11 80 	movzbl 0x801137c0,%ecx
801037f3:	39 c8                	cmp    %ecx,%eax
801037f5:	74 21                	je     80103818 <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
801037f7:	83 fa 01             	cmp    $0x1,%edx
801037fa:	74 0b                	je     80103807 <mycpu+0x37>
    if (cpus[i].apicid == apicid)
801037fc:	0f b6 15 70 38 11 80 	movzbl 0x80113870,%edx
80103803:	39 d0                	cmp    %edx,%eax
80103805:	74 19                	je     80103820 <mycpu+0x50>
  panic("unknown apicid\n");
80103807:	83 ec 0c             	sub    $0xc,%esp
8010380a:	68 1c 86 10 80       	push   $0x8010861c
8010380f:	e8 7c cb ff ff       	call   80100390 <panic>
80103814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpus[i].apicid == apicid)
80103818:	b8 c0 37 11 80       	mov    $0x801137c0,%eax
}
8010381d:	c9                   	leave  
8010381e:	c3                   	ret    
8010381f:	90                   	nop
    if (cpus[i].apicid == apicid)
80103820:	b8 70 38 11 80       	mov    $0x80113870,%eax
}
80103825:	c9                   	leave  
80103826:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
80103827:	83 ec 0c             	sub    $0xc,%esp
8010382a:	68 7c 87 10 80       	push   $0x8010877c
8010382f:	e8 5c cb ff ff       	call   80100390 <panic>
80103834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010383a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103840 <cpuid>:
cpuid() {
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103846:	e8 85 ff ff ff       	call   801037d0 <mycpu>
8010384b:	2d c0 37 11 80       	sub    $0x801137c0,%eax
}
80103850:	c9                   	leave  
  return mycpu()-cpus;
80103851:	c1 f8 04             	sar    $0x4,%eax
80103854:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010385a:	c3                   	ret    
8010385b:	90                   	nop
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103860 <myproc>:
myproc(void) {
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	53                   	push   %ebx
80103864:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103867:	e8 a4 1a 00 00       	call   80105310 <pushcli>
  c = mycpu();
8010386c:	e8 5f ff ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103871:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103877:	e8 d4 1a 00 00       	call   80105350 <popcli>
}
8010387c:	83 c4 04             	add    $0x4,%esp
8010387f:	89 d8                	mov    %ebx,%eax
80103881:	5b                   	pop    %ebx
80103882:	5d                   	pop    %ebp
80103883:	c3                   	ret    
80103884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010388a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103890 <userinit>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103897:	e8 64 fd ff ff       	call   80103600 <allocproc>
8010389c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010389e:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
801038a3:	e8 68 45 00 00       	call   80107e10 <setupkvm>
801038a8:	85 c0                	test   %eax,%eax
801038aa:	89 43 04             	mov    %eax,0x4(%ebx)
801038ad:	0f 84 bd 00 00 00    	je     80103970 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038b3:	83 ec 04             	sub    $0x4,%esp
801038b6:	68 2c 00 00 00       	push   $0x2c
801038bb:	68 80 b4 10 80       	push   $0x8010b480
801038c0:	50                   	push   %eax
801038c1:	e8 2a 42 00 00       	call   80107af0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038cf:	6a 4c                	push   $0x4c
801038d1:	6a 00                	push   $0x0
801038d3:	ff 73 18             	pushl  0x18(%ebx)
801038d6:	e8 15 1c 00 00       	call   801054f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038db:	8b 43 18             	mov    0x18(%ebx),%eax
801038de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038e3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038e8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038ef:	8b 43 18             	mov    0x18(%ebx),%eax
801038f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038f6:	8b 43 18             	mov    0x18(%ebx),%eax
801038f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103901:	8b 43 18             	mov    0x18(%ebx),%eax
80103904:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103908:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010390c:	8b 43 18             	mov    0x18(%ebx),%eax
8010390f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103916:	8b 43 18             	mov    0x18(%ebx),%eax
80103919:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103920:	8b 43 18             	mov    0x18(%ebx),%eax
80103923:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010392a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010392d:	6a 10                	push   $0x10
8010392f:	68 45 86 10 80       	push   $0x80108645
80103934:	50                   	push   %eax
80103935:	e8 96 1d 00 00       	call   801056d0 <safestrcpy>
  p->cwd = namei("/");
8010393a:	c7 04 24 4e 86 10 80 	movl   $0x8010864e,(%esp)
80103941:	e8 9a e5 ff ff       	call   80101ee0 <namei>
80103946:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103949:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103950:	e8 8b 1a 00 00       	call   801053e0 <acquire>
  p->state = RUNNABLE;
80103955:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010395c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103963:	e8 38 1b 00 00       	call   801054a0 <release>
}
80103968:	83 c4 10             	add    $0x10,%esp
8010396b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010396e:	c9                   	leave  
8010396f:	c3                   	ret    
    panic("userinit: out of memory?");
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	68 2c 86 10 80       	push   $0x8010862c
80103978:	e8 13 ca ff ff       	call   80100390 <panic>
8010397d:	8d 76 00             	lea    0x0(%esi),%esi

80103980 <growproc>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
80103985:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103988:	e8 83 19 00 00       	call   80105310 <pushcli>
  c = mycpu();
8010398d:	e8 3e fe ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103992:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103998:	e8 b3 19 00 00       	call   80105350 <popcli>
  if(n > 0){
8010399d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801039a0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039a2:	7f 1c                	jg     801039c0 <growproc+0x40>
  } else if(n < 0){
801039a4:	75 3a                	jne    801039e0 <growproc+0x60>
  switchuvm(curproc);
801039a6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039a9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039ab:	53                   	push   %ebx
801039ac:	e8 2f 40 00 00       	call   801079e0 <switchuvm>
  return 0;
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	31 c0                	xor    %eax,%eax
}
801039b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039b9:	5b                   	pop    %ebx
801039ba:	5e                   	pop    %esi
801039bb:	5d                   	pop    %ebp
801039bc:	c3                   	ret    
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039c0:	83 ec 04             	sub    $0x4,%esp
801039c3:	01 c6                	add    %eax,%esi
801039c5:	56                   	push   %esi
801039c6:	50                   	push   %eax
801039c7:	ff 73 04             	pushl  0x4(%ebx)
801039ca:	e8 61 42 00 00       	call   80107c30 <allocuvm>
801039cf:	83 c4 10             	add    $0x10,%esp
801039d2:	85 c0                	test   %eax,%eax
801039d4:	75 d0                	jne    801039a6 <growproc+0x26>
      return -1;
801039d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039db:	eb d9                	jmp    801039b6 <growproc+0x36>
801039dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039e0:	83 ec 04             	sub    $0x4,%esp
801039e3:	01 c6                	add    %eax,%esi
801039e5:	56                   	push   %esi
801039e6:	50                   	push   %eax
801039e7:	ff 73 04             	pushl  0x4(%ebx)
801039ea:	e8 71 43 00 00       	call   80107d60 <deallocuvm>
801039ef:	83 c4 10             	add    $0x10,%esp
801039f2:	85 c0                	test   %eax,%eax
801039f4:	75 b0                	jne    801039a6 <growproc+0x26>
801039f6:	eb de                	jmp    801039d6 <growproc+0x56>
801039f8:	90                   	nop
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a00 <fork>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a09:	e8 02 19 00 00       	call   80105310 <pushcli>
  c = mycpu();
80103a0e:	e8 bd fd ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103a13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a19:	e8 32 19 00 00       	call   80105350 <popcli>
  if((np = allocproc()) == 0){
80103a1e:	e8 dd fb ff ff       	call   80103600 <allocproc>
80103a23:	85 c0                	test   %eax,%eax
80103a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a28:	0f 84 b7 00 00 00    	je     80103ae5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a2e:	83 ec 08             	sub    $0x8,%esp
80103a31:	ff 33                	pushl  (%ebx)
80103a33:	ff 73 04             	pushl  0x4(%ebx)
80103a36:	89 c7                	mov    %eax,%edi
80103a38:	e8 a3 44 00 00       	call   80107ee0 <copyuvm>
80103a3d:	83 c4 10             	add    $0x10,%esp
80103a40:	85 c0                	test   %eax,%eax
80103a42:	89 47 04             	mov    %eax,0x4(%edi)
80103a45:	0f 84 a1 00 00 00    	je     80103aec <fork+0xec>
  np->sz = curproc->sz;
80103a4b:	8b 03                	mov    (%ebx),%eax
80103a4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a50:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a52:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a55:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a57:	8b 79 18             	mov    0x18(%ecx),%edi
80103a5a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a5d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a66:	8b 40 18             	mov    0x18(%eax),%eax
80103a69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a74:	85 c0                	test   %eax,%eax
80103a76:	74 13                	je     80103a8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a78:	83 ec 0c             	sub    $0xc,%esp
80103a7b:	50                   	push   %eax
80103a7c:	e8 6f d3 ff ff       	call   80100df0 <filedup>
80103a81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a84:	83 c4 10             	add    $0x10,%esp
80103a87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a8b:	83 c6 01             	add    $0x1,%esi
80103a8e:	83 fe 10             	cmp    $0x10,%esi
80103a91:	75 dd                	jne    80103a70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a93:	83 ec 0c             	sub    $0xc,%esp
80103a96:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103a9c:	e8 af db ff ff       	call   80101650 <idup>
80103aa1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aa4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103aa7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aaa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103aad:	6a 10                	push   $0x10
80103aaf:	53                   	push   %ebx
80103ab0:	50                   	push   %eax
80103ab1:	e8 1a 1c 00 00       	call   801056d0 <safestrcpy>
  pid = np->pid;
80103ab6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ab9:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ac0:	e8 1b 19 00 00       	call   801053e0 <acquire>
  np->state = RUNNABLE;
80103ac5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103acc:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ad3:	e8 c8 19 00 00       	call   801054a0 <release>
  return pid;
80103ad8:	83 c4 10             	add    $0x10,%esp
}
80103adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ade:	89 d8                	mov    %ebx,%eax
80103ae0:	5b                   	pop    %ebx
80103ae1:	5e                   	pop    %esi
80103ae2:	5f                   	pop    %edi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret    
    return -1;
80103ae5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103aea:	eb ef                	jmp    80103adb <fork+0xdb>
    kfree(np->kstack);
80103aec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103aef:	83 ec 0c             	sub    $0xc,%esp
80103af2:	ff 73 08             	pushl  0x8(%ebx)
80103af5:	e8 16 e8 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103afa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b01:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b08:	83 c4 10             	add    $0x10,%esp
80103b0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b10:	eb c9                	jmp    80103adb <fork+0xdb>
80103b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b20 <cps>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80103b27:	fb                   	sti    
  acquire(&ptable.lock);
80103b28:	68 40 3d 11 80       	push   $0x80113d40
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b2d:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
  acquire(&ptable.lock);
80103b32:	e8 a9 18 00 00       	call   801053e0 <acquire>
  cprintf("name \t pid \t queueNo \t ticks \t state \t priority\n");
80103b37:	c7 04 24 a4 87 10 80 	movl   $0x801087a4,(%esp)
80103b3e:	e8 1d cb ff ff       	call   80100660 <cprintf>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	eb 24                	jmp    80103b6c <cps+0x4c>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      else if ( p->state == RUNNING )
80103b50:	83 f8 04             	cmp    $0x4,%eax
80103b53:	74 73                	je     80103bc8 <cps+0xa8>
  	  else if ( p->state == RUNNABLE )
80103b55:	83 f8 03             	cmp    $0x3,%eax
80103b58:	0f 84 a2 00 00 00    	je     80103c00 <cps+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b5e:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103b64:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80103b6a:	73 41                	jae    80103bad <cps+0x8d>
      if ( p->state == SLEEPING )
80103b6c:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b6f:	83 f8 02             	cmp    $0x2,%eax
80103b72:	75 dc                	jne    80103b50 <cps+0x30>
        cprintf("%s \t %d  \t %d  \t %d  \t SLEEPING \t %d\n  ", p->name, p->pid ,p->current_queue,p->ticks[p->current_queue],p->priority);
80103b74:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
80103b7a:	83 ec 08             	sub    $0x8,%esp
80103b7d:	ff b3 a8 00 00 00    	pushl  0xa8(%ebx)
80103b83:	ff b4 83 90 00 00 00 	pushl  0x90(%ebx,%eax,4)
80103b8a:	50                   	push   %eax
80103b8b:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b8e:	ff 73 10             	pushl  0x10(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b91:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
        cprintf("%s \t %d  \t %d  \t %d  \t SLEEPING \t %d\n  ", p->name, p->pid ,p->current_queue,p->ticks[p->current_queue],p->priority);
80103b97:	50                   	push   %eax
80103b98:	68 d8 87 10 80       	push   $0x801087d8
80103b9d:	e8 be ca ff ff       	call   80100660 <cprintf>
80103ba2:	83 c4 20             	add    $0x20,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba5:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80103bab:	72 bf                	jb     80103b6c <cps+0x4c>
  release(&ptable.lock);
80103bad:	83 ec 0c             	sub    $0xc,%esp
80103bb0:	68 40 3d 11 80       	push   $0x80113d40
80103bb5:	e8 e6 18 00 00       	call   801054a0 <release>
}
80103bba:	b8 17 00 00 00       	mov    $0x17,%eax
80103bbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc2:	c9                   	leave  
80103bc3:	c3                   	ret    
80103bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%s \t %d  \t %d  \t %d  \t RUNNING \t %d\n ", p->name, p->pid,p->current_queue,p->ticks[p->current_queue],p->priority );
80103bc8:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
80103bce:	83 ec 08             	sub    $0x8,%esp
80103bd1:	ff b3 a8 00 00 00    	pushl  0xa8(%ebx)
80103bd7:	ff b4 83 90 00 00 00 	pushl  0x90(%ebx,%eax,4)
80103bde:	50                   	push   %eax
80103bdf:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103be2:	ff 73 10             	pushl  0x10(%ebx)
80103be5:	50                   	push   %eax
80103be6:	68 00 88 10 80       	push   $0x80108800
80103beb:	e8 70 ca ff ff       	call   80100660 <cprintf>
80103bf0:	83 c4 20             	add    $0x20,%esp
80103bf3:	e9 66 ff ff ff       	jmp    80103b5e <cps+0x3e>
80103bf8:	90                   	nop
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%s \t %d  \t %d  \t %d  \t RUNNABLE \t %d\n ", p->name, p->pid,p->current_queue,p->ticks[p->current_queue],p->priority );	
80103c00:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
80103c06:	83 ec 08             	sub    $0x8,%esp
80103c09:	ff b3 a8 00 00 00    	pushl  0xa8(%ebx)
80103c0f:	ff b4 83 90 00 00 00 	pushl  0x90(%ebx,%eax,4)
80103c16:	50                   	push   %eax
80103c17:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c1a:	ff 73 10             	pushl  0x10(%ebx)
80103c1d:	50                   	push   %eax
80103c1e:	68 28 88 10 80       	push   $0x80108828
80103c23:	e8 38 ca ff ff       	call   80100660 <cprintf>
80103c28:	83 c4 20             	add    $0x20,%esp
80103c2b:	e9 2e ff ff ff       	jmp    80103b5e <cps+0x3e>

80103c30 <set_priority>:
int set_priority(int pid,int new_priority){
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 10             	sub    $0x10,%esp
80103c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80103c3a:	68 40 3d 11 80       	push   $0x80113d40
80103c3f:	e8 9c 17 00 00       	call   801053e0 <acquire>
80103c44:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c47:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
80103c4c:	eb 10                	jmp    80103c5e <set_priority+0x2e>
80103c4e:	66 90                	xchg   %ax,%ax
80103c50:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103c56:	81 fa 74 69 11 80    	cmp    $0x80116974,%edx
80103c5c:	73 32                	jae    80103c90 <set_priority+0x60>
    if(p->pid == pid ) {
80103c5e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103c61:	75 ed                	jne    80103c50 <set_priority+0x20>
        p->priority = new_priority;
80103c63:	8b 45 0c             	mov    0xc(%ebp),%eax
        old_priority = p->priority;
80103c66:	8b 9a a8 00 00 00    	mov    0xa8(%edx),%ebx
        p->priority = new_priority;
80103c6c:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
  	release(&ptable.lock);
80103c72:	83 ec 0c             	sub    $0xc,%esp
80103c75:	68 40 3d 11 80       	push   $0x80113d40
80103c7a:	e8 21 18 00 00       	call   801054a0 <release>
}
80103c7f:	89 d8                	mov    %ebx,%eax
80103c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c84:	c9                   	leave  
80103c85:	c3                   	ret    
80103c86:	8d 76 00             	lea    0x0(%esi),%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    int old_priority=-1;
80103c90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c95:	eb db                	jmp    80103c72 <set_priority+0x42>
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <getpinfo>:
int getpinfo(struct proc_stat*process_stat,int here_pid){
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca6:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
int getpinfo(struct proc_stat*process_stat,int here_pid){
80103cab:	83 ec 18             	sub    $0x18,%esp
80103cae:	8b 75 08             	mov    0x8(%ebp),%esi
80103cb1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  	acquire(&ptable.lock);
80103cb4:	68 40 3d 11 80       	push   $0x80113d40
80103cb9:	e8 22 17 00 00       	call   801053e0 <acquire>
80103cbe:	83 c4 10             	add    $0x10,%esp
80103cc1:	eb 17                	jmp    80103cda <getpinfo+0x3a>
80103cc3:	90                   	nop
80103cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103cce:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80103cd4:	0f 83 db 00 00 00    	jae    80103db5 <getpinfo+0x115>
  		if(p->pid==here_pid){
80103cda:	39 7b 10             	cmp    %edi,0x10(%ebx)
80103cdd:	75 e9                	jne    80103cc8 <getpinfo+0x28>
  			process_stat->num_run = p->num_run;
80103cdf:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
			cprintf("pid : %d\n",(process_stat->pid));
80103ce5:	83 ec 08             	sub    $0x8,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
  			process_stat->num_run = p->num_run;
80103cee:	89 46 08             	mov    %eax,0x8(%esi)
			process_stat->runtime = p->rtime;
80103cf1:	8b 43 d4             	mov    -0x2c(%ebx),%eax
80103cf4:	89 46 04             	mov    %eax,0x4(%esi)
			process_stat->pid = p->pid;
80103cf7:	8b 83 60 ff ff ff    	mov    -0xa0(%ebx),%eax
80103cfd:	89 06                	mov    %eax,(%esi)
			process_stat->ticks[0] = p->ticks[0];
80103cff:	8b 53 e0             	mov    -0x20(%ebx),%edx
80103d02:	89 56 10             	mov    %edx,0x10(%esi)
			process_stat->ticks[1] = p->ticks[1];
80103d05:	8b 53 e4             	mov    -0x1c(%ebx),%edx
80103d08:	89 56 14             	mov    %edx,0x14(%esi)
			process_stat->ticks[2] = p->ticks[2];
80103d0b:	8b 53 e8             	mov    -0x18(%ebx),%edx
80103d0e:	89 56 18             	mov    %edx,0x18(%esi)
			process_stat->ticks[3] = p->ticks[3];
80103d11:	8b 53 ec             	mov    -0x14(%ebx),%edx
80103d14:	89 56 1c             	mov    %edx,0x1c(%esi)
			process_stat->ticks[4] = p->ticks[4];
80103d17:	8b 53 f0             	mov    -0x10(%ebx),%edx
80103d1a:	89 56 20             	mov    %edx,0x20(%esi)
			process_stat->current_queue = p->current_queue;
80103d1d:	8b 53 f4             	mov    -0xc(%ebx),%edx
80103d20:	89 56 0c             	mov    %edx,0xc(%esi)
			cprintf("pid : %d\n",(process_stat->pid));
80103d23:	50                   	push   %eax
80103d24:	68 50 86 10 80       	push   $0x80108650
80103d29:	e8 32 c9 ff ff       	call   80100660 <cprintf>
  	cprintf("runtime : %d\n",process_stat->runtime);
80103d2e:	58                   	pop    %eax
80103d2f:	5a                   	pop    %edx
80103d30:	ff 76 04             	pushl  0x4(%esi)
80103d33:	68 5a 86 10 80       	push   $0x8010865a
80103d38:	e8 23 c9 ff ff       	call   80100660 <cprintf>
  	cprintf("num_run : %d\n",process_stat->num_run);
80103d3d:	59                   	pop    %ecx
80103d3e:	58                   	pop    %eax
80103d3f:	ff 76 08             	pushl  0x8(%esi)
80103d42:	68 68 86 10 80       	push   $0x80108668
80103d47:	e8 14 c9 ff ff       	call   80100660 <cprintf>
  	cprintf("current_queue : %d\n",process_stat->current_queue);
80103d4c:	58                   	pop    %eax
80103d4d:	5a                   	pop    %edx
80103d4e:	ff 76 0c             	pushl  0xc(%esi)
80103d51:	68 76 86 10 80       	push   $0x80108676
80103d56:	e8 05 c9 ff ff       	call   80100660 <cprintf>
  	cprintf("ticks[0] : %d\n",process_stat->ticks[0]);
80103d5b:	59                   	pop    %ecx
80103d5c:	58                   	pop    %eax
80103d5d:	ff 76 10             	pushl  0x10(%esi)
80103d60:	68 8a 86 10 80       	push   $0x8010868a
80103d65:	e8 f6 c8 ff ff       	call   80100660 <cprintf>
  	cprintf("ticks[1] : %d\n",process_stat->ticks[1]);
80103d6a:	58                   	pop    %eax
80103d6b:	5a                   	pop    %edx
80103d6c:	ff 76 14             	pushl  0x14(%esi)
80103d6f:	68 99 86 10 80       	push   $0x80108699
80103d74:	e8 e7 c8 ff ff       	call   80100660 <cprintf>
  	cprintf("ticks[2] : %d\n",process_stat->ticks[2]);
80103d79:	59                   	pop    %ecx
80103d7a:	58                   	pop    %eax
80103d7b:	ff 76 18             	pushl  0x18(%esi)
80103d7e:	68 a8 86 10 80       	push   $0x801086a8
80103d83:	e8 d8 c8 ff ff       	call   80100660 <cprintf>
  	cprintf("ticks[3] : %d\n",process_stat->ticks[3]);
80103d88:	58                   	pop    %eax
80103d89:	5a                   	pop    %edx
80103d8a:	ff 76 1c             	pushl  0x1c(%esi)
80103d8d:	68 b7 86 10 80       	push   $0x801086b7
80103d92:	e8 c9 c8 ff ff       	call   80100660 <cprintf>
  	cprintf("ticks[4] : %d\n",process_stat->ticks[4]);
80103d97:	59                   	pop    %ecx
80103d98:	58                   	pop    %eax
80103d99:	ff 76 20             	pushl  0x20(%esi)
80103d9c:	68 c6 86 10 80       	push   $0x801086c6
80103da1:	e8 ba c8 ff ff       	call   80100660 <cprintf>
80103da6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da9:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80103daf:	0f 82 25 ff ff ff    	jb     80103cda <getpinfo+0x3a>
  release(&ptable.lock);
80103db5:	83 ec 0c             	sub    $0xc,%esp
80103db8:	68 40 3d 11 80       	push   $0x80113d40
80103dbd:	e8 de 16 00 00       	call   801054a0 <release>
}
80103dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc5:	31 c0                	xor    %eax,%eax
80103dc7:	5b                   	pop    %ebx
80103dc8:	5e                   	pop    %esi
80103dc9:	5f                   	pop    %edi
80103dca:	5d                   	pop    %ebp
80103dcb:	c3                   	ret    
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <scheduler>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 4c             	sub    $0x4c,%esp
  struct cpu *c = mycpu();
80103dd9:	e8 f2 f9 ff ff       	call   801037d0 <mycpu>
  c->proc = 0;
80103dde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103de5:	00 00 00 
  struct cpu *c = mycpu();
80103de8:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103deb:	83 c0 04             	add    $0x4,%eax
80103dee:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103df8:	fb                   	sti    
    acquire(&tickslock);
80103df9:	83 ec 0c             	sub    $0xc,%esp
80103dfc:	68 80 6a 11 80       	push   $0x80116a80
80103e01:	e8 da 15 00 00       	call   801053e0 <acquire>
    xticks = ticks;
80103e06:	a1 c0 72 11 80       	mov    0x801172c0,%eax
    release(&tickslock);
80103e0b:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
    xticks = ticks;
80103e12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    release(&tickslock);
80103e15:	e8 86 16 00 00       	call   801054a0 <release>
    acquire(&ptable.lock);
80103e1a:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103e21:	e8 ba 15 00 00       	call   801053e0 <acquire>
80103e26:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80103e2b:	83 c4 10             	add    $0x10,%esp
80103e2e:	c6 45 b4 00          	movb   $0x0,-0x4c(%ebp)
80103e32:	c6 45 bb 00          	movb   $0x0,-0x45(%ebp)
80103e36:	c6 45 c8 00          	movb   $0x0,-0x38(%ebp)
80103e3a:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
80103e3e:	c6 45 cc 00          	movb   $0x0,-0x34(%ebp)
80103e42:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103e45:	a1 24 b0 10 80       	mov    0x8010b024,%eax
80103e4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103e4d:	a1 28 b0 10 80       	mov    0x8010b028,%eax
80103e52:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103e55:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
80103e5a:	89 45 b0             	mov    %eax,-0x50(%ebp)
80103e5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103e60:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
80103e65:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103e68:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
          if( ptable.proc[j].state != RUNNABLE) continue;
80103e70:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e74:	0f 85 de 00 00 00    	jne    80103f58 <scheduler+0x188>
          if(ptable.proc[j].current_queue > 0 && xticks - ptable.proc[j].lastexperiencedtick >= 100){
80103e7a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80103e80:	85 d2                	test   %edx,%edx
80103e82:	0f 8e d0 00 00 00    	jle    80103f58 <scheduler+0x188>
80103e88:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e8b:	2b 88 ac 00 00 00    	sub    0xac(%eax),%ecx
80103e91:	83 f9 63             	cmp    $0x63,%ecx
80103e94:	0f 86 be 00 00 00    	jbe    80103f58 <scheduler+0x188>
            if(ptable.proc[j].current_queue==1){
80103e9a:	83 fa 01             	cmp    $0x1,%edx
80103e9d:	0f 84 ed 05 00 00    	je     80104490 <scheduler+0x6c0>
            if(ptable.proc[j].current_queue==2){
80103ea3:	83 fa 02             	cmp    $0x2,%edx
80103ea6:	0f 84 44 05 00 00    	je     801043f0 <scheduler+0x620>
            if(ptable.proc[j].current_queue==3){
80103eac:	83 fa 03             	cmp    $0x3,%edx
80103eaf:	0f 84 93 04 00 00    	je     80104348 <scheduler+0x578>
            if(ptable.proc[j].current_queue==4){
80103eb5:	83 fa 04             	cmp    $0x4,%edx
80103eb8:	0f 85 8b 00 00 00    	jne    80103f49 <scheduler+0x179>
            	for(int y=0;y<=c4;y++){
80103ebe:	8b 4d c0             	mov    -0x40(%ebp),%ecx
80103ec1:	85 c9                	test   %ecx,%ecx
80103ec3:	78 72                	js     80103f37 <scheduler+0x167>
            		if(q4[y]->pid==ptable.proc[j].pid){
80103ec5:	8b 78 10             	mov    0x10(%eax),%edi
            	for(int y=0;y<=c4;y++){
80103ec8:	31 db                	xor    %ebx,%ebx
80103eca:	89 55 c0             	mov    %edx,-0x40(%ebp)
80103ecd:	eb 08                	jmp    80103ed7 <scheduler+0x107>
80103ecf:	90                   	nop
80103ed0:	83 c3 01             	add    $0x1,%ebx
80103ed3:	39 cb                	cmp    %ecx,%ebx
80103ed5:	7f 5a                	jg     80103f31 <scheduler+0x161>
            		if(q4[y]->pid==ptable.proc[j].pid){
80103ed7:	8b 14 9d 80 69 11 80 	mov    -0x7fee9680(,%ebx,4),%edx
80103ede:	39 7a 10             	cmp    %edi,0x10(%edx)
80103ee1:	75 ed                	jne    80103ed0 <scheduler+0x100>
					  for(z=y;z<=c4-1;z++)
80103ee3:	39 d9                	cmp    %ebx,%ecx
            			 q4[y]=NULL;
80103ee5:	c7 04 9d 80 69 11 80 	movl   $0x0,-0x7fee9680(,%ebx,4)
80103eec:	00 00 00 00 
					  for(z=y;z<=c4-1;z++)
80103ef0:	7e 26                	jle    80103f18 <scheduler+0x148>
80103ef2:	8d 14 9d 80 69 11 80 	lea    -0x7fee9680(,%ebx,4),%edx
80103ef9:	8d 34 8d 80 69 11 80 	lea    -0x7fee9680(,%ecx,4),%esi
80103f00:	89 45 c8             	mov    %eax,-0x38(%ebp)
80103f03:	90                   	nop
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					  q4[z] = q4[z+1];
80103f08:	8b 42 04             	mov    0x4(%edx),%eax
80103f0b:	83 c2 04             	add    $0x4,%edx
80103f0e:	89 42 fc             	mov    %eax,-0x4(%edx)
					  for(z=y;z<=c4-1;z++)
80103f11:	39 f2                	cmp    %esi,%edx
80103f13:	75 f3                	jne    80103f08 <scheduler+0x138>
80103f15:	8b 45 c8             	mov    -0x38(%ebp),%eax
					  q4[c4] = NULL;
80103f18:	c7 04 8d 80 69 11 80 	movl   $0x0,-0x7fee9680(,%ecx,4)
80103f1f:	00 00 00 00 
            	for(int y=0;y<=c4;y++){
80103f23:	83 c3 01             	add    $0x1,%ebx
					  c4--;
80103f26:	83 e9 01             	sub    $0x1,%ecx
            	for(int y=0;y<=c4;y++){
80103f29:	39 cb                	cmp    %ecx,%ebx
					  c4--;
80103f2b:	c6 45 bb 01          	movb   $0x1,-0x45(%ebp)
            	for(int y=0;y<=c4;y++){
80103f2f:	7e a6                	jle    80103ed7 <scheduler+0x107>
80103f31:	8b 55 c0             	mov    -0x40(%ebp),%edx
80103f34:	89 4d c0             	mov    %ecx,-0x40(%ebp)
            	c3++;
80103f37:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
            	q3[c3]=&ptable.proc[j];
80103f3b:	c6 45 c8 01          	movb   $0x1,-0x38(%ebp)
            	c3++;
80103f3f:	8b 75 d8             	mov    -0x28(%ebp),%esi
            	q3[c3]=&ptable.proc[j];
80103f42:	89 04 b5 40 3a 11 80 	mov    %eax,-0x7feec5c0(,%esi,4)
            ptable.proc[j].current_queue--;
80103f49:	83 ea 01             	sub    $0x1,%edx
80103f4c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f58:	05 b0 00 00 00       	add    $0xb0,%eax
    	for(j = 0; j < NPROC; ++j){
80103f5d:	3d 74 69 11 80       	cmp    $0x80116974,%eax
80103f62:	0f 85 08 ff ff ff    	jne    80103e70 <scheduler+0xa0>
80103f68:	80 7d cc 00          	cmpb   $0x0,-0x34(%ebp)
80103f6c:	0f 85 ff 0a 00 00    	jne    80104a71 <scheduler+0xca1>
80103f72:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
80103f76:	74 08                	je     80103f80 <scheduler+0x1b0>
80103f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f7b:	a3 24 b0 10 80       	mov    %eax,0x8010b024
80103f80:	80 7d c8 00          	cmpb   $0x0,-0x38(%ebp)
80103f84:	74 08                	je     80103f8e <scheduler+0x1be>
80103f86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103f89:	a3 20 b0 10 80       	mov    %eax,0x8010b020
80103f8e:	80 7d bb 00          	cmpb   $0x0,-0x45(%ebp)
80103f92:	74 08                	je     80103f9c <scheduler+0x1cc>
80103f94:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103f97:	a3 1c b0 10 80       	mov    %eax,0x8010b01c
80103f9c:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
80103fa0:	0f 85 be 0a 00 00    	jne    80104a64 <scheduler+0xc94>
80103fa6:	8b 45 b0             	mov    -0x50(%ebp),%eax
80103fa9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    	if(c0!=-1){
80103fac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80103faf:	85 c9                	test   %ecx,%ecx
80103fb1:	0f 88 a1 00 00 00    	js     80104058 <scheduler+0x288>
					for(i=0;i<=c0;i++){
80103fb7:	31 db                	xor    %ebx,%ebx
80103fb9:	8b 75 d0             	mov    -0x30(%ebp),%esi
80103fbc:	eb 0d                	jmp    80103fcb <scheduler+0x1fb>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	83 c3 01             	add    $0x1,%ebx
80103fc3:	39 cb                	cmp    %ecx,%ebx
80103fc5:	0f 8f 8d 00 00 00    	jg     80104058 <scheduler+0x288>
						if(q0[i]->state != RUNNABLE)
80103fcb:	8b 3c 9d 40 3c 11 80 	mov    -0x7feec3c0(,%ebx,4),%edi
80103fd2:	8b 0d 2c b0 10 80    	mov    0x8010b02c,%ecx
80103fd8:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103fdc:	75 e2                	jne    80103fc0 <scheduler+0x1f0>
					  p->lastexperiencedtick = xticks;
80103fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
					  switchuvm(p);
80103fe1:	83 ec 0c             	sub    $0xc,%esp
					  c->proc = q0[i];
80103fe4:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
					  p->lastexperiencedtick = xticks;
80103fea:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
					  switchuvm(p);
80103ff0:	57                   	push   %edi
80103ff1:	e8 ea 39 00 00       	call   801079e0 <switchuvm>
					  p->num_run++;
80103ff6:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
					  p->state = RUNNING;
80103ffd:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
					  swtch(&(c->scheduler), p->context);
80104004:	58                   	pop    %eax
80104005:	5a                   	pop    %edx
80104006:	ff 77 1c             	pushl  0x1c(%edi)
80104009:	ff 75 bc             	pushl  -0x44(%ebp)
8010400c:	e8 1a 17 00 00       	call   8010572b <swtch>
					  switchkvm();
80104011:	e8 aa 39 00 00       	call   801079c0 <switchkvm>
					  if(p->ticks[0]!=0 && p->ticks[0]%(clkPerPrio[0]*10)==0){
80104016:	8b 87 90 00 00 00    	mov    0x90(%edi),%eax
8010401c:	83 c4 10             	add    $0x10,%esp
8010401f:	8b 0d 2c b0 10 80    	mov    0x8010b02c,%ecx
80104025:	85 c0                	test   %eax,%eax
80104027:	74 16                	je     8010403f <scheduler+0x26f>
80104029:	8b 15 08 b0 10 80    	mov    0x8010b008,%edx
8010402f:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80104032:	99                   	cltd   
80104033:	01 ff                	add    %edi,%edi
80104035:	f7 ff                	idiv   %edi
80104037:	85 d2                	test   %edx,%edx
80104039:	0f 84 67 09 00 00    	je     801049a6 <scheduler+0xbd6>
					for(i=0;i<=c0;i++){
8010403f:	83 c3 01             	add    $0x1,%ebx
					  c->proc = 0;
80104042:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104049:	00 00 00 
					for(i=0;i<=c0;i++){
8010404c:	39 cb                	cmp    %ecx,%ebx
8010404e:	0f 8e 77 ff ff ff    	jle    80103fcb <scheduler+0x1fb>
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(c1!=-1){
80104058:	8b 0d 28 b0 10 80    	mov    0x8010b028,%ecx
8010405e:	85 c9                	test   %ecx,%ecx
80104060:	78 64                	js     801040c6 <scheduler+0x2f6>
			for(i=0;i<=c1;i++){
80104062:	8b 75 d0             	mov    -0x30(%ebp),%esi
80104065:	31 db                	xor    %ebx,%ebx
80104067:	89 f6                	mov    %esi,%esi
80104069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
				for(int u=0;u<=c0;u++){
80104070:	8b 3d 2c b0 10 80    	mov    0x8010b02c,%edi
80104076:	85 ff                	test   %edi,%edi
80104078:	78 2e                	js     801040a8 <scheduler+0x2d8>
						if(q0[u]->state == RUNNABLE){
8010407a:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
80104080:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104084:	0f 84 b6 07 00 00    	je     80104840 <scheduler+0xa70>
				for(int u=0;u<=c0;u++){
8010408a:	31 c0                	xor    %eax,%eax
8010408c:	eb 13                	jmp    801040a1 <scheduler+0x2d1>
8010408e:	66 90                	xchg   %ax,%ax
						if(q0[u]->state == RUNNABLE){
80104090:	8b 0c 85 40 3c 11 80 	mov    -0x7feec3c0(,%eax,4),%ecx
80104097:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
8010409b:	0f 84 9f 07 00 00    	je     80104840 <scheduler+0xa70>
				for(int u=0;u<=c0;u++){
801040a1:	83 c0 01             	add    $0x1,%eax
801040a4:	39 f8                	cmp    %edi,%eax
801040a6:	7e e8                	jle    80104090 <scheduler+0x2c0>
				if(q1[i]->state != RUNNABLE)
801040a8:	8b 3c 9d 40 3b 11 80 	mov    -0x7feec4c0(,%ebx,4),%edi
801040af:	8b 0d 28 b0 10 80    	mov    0x8010b028,%ecx
801040b5:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
801040b9:	0f 84 11 05 00 00    	je     801045d0 <scheduler+0x800>
			for(i=0;i<=c1;i++){
801040bf:	83 c3 01             	add    $0x1,%ebx
801040c2:	39 cb                	cmp    %ecx,%ebx
801040c4:	7e aa                	jle    80104070 <scheduler+0x2a0>
				if(c2!=-1){
801040c6:	8b 3d 24 b0 10 80    	mov    0x8010b024,%edi
801040cc:	85 ff                	test   %edi,%edi
801040ce:	0f 89 f8 05 00 00    	jns    801046cc <scheduler+0x8fc>
				if(c3!=-1){
801040d4:	a1 20 b0 10 80       	mov    0x8010b020,%eax
801040d9:	85 c0                	test   %eax,%eax
801040db:	0f 88 c4 04 00 00    	js     801045a5 <scheduler+0x7d5>
						for(int u=0;u<=c0;u++){
801040e1:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
					for(i=0;i<=c3;i++){
801040e6:	31 db                	xor    %ebx,%ebx
						for(int u=0;u<=c0;u++){
801040e8:	31 c9                	xor    %ecx,%ecx
801040ea:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
801040f0:	85 c0                	test   %eax,%eax
801040f2:	78 3d                	js     80104131 <scheduler+0x361>
						if(q0[u]->state == RUNNABLE){
801040f4:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801040f8:	0f 84 e2 00 00 00    	je     801041e0 <scheduler+0x410>
801040fe:	66 90                	xchg   %ax,%ax
						for(int u=0;u<=c0;u++){
80104100:	8b 35 2c b0 10 80    	mov    0x8010b02c,%esi
80104106:	31 c0                	xor    %eax,%eax
80104108:	eb 17                	jmp    80104121 <scheduler+0x351>
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
						if(q0[u]->state == RUNNABLE){
80104110:	8b 14 85 40 3c 11 80 	mov    -0x7feec3c0(,%eax,4),%edx
80104117:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010411b:	0f 84 bf 00 00 00    	je     801041e0 <scheduler+0x410>
						for(int u=0;u<=c0;u++){
80104121:	83 c0 01             	add    $0x1,%eax
80104124:	39 c6                	cmp    %eax,%esi
80104126:	7d e8                	jge    80104110 <scheduler+0x340>
					if(flag1==1){
80104128:	83 f9 01             	cmp    $0x1,%ecx
8010412b:	0f 84 af 00 00 00    	je     801041e0 <scheduler+0x410>
80104131:	8d 34 9d 40 3a 11 80 	lea    -0x7feec5c0(,%ebx,4),%esi
					for(int u=0;u<=c1;u++){
80104138:	8b 0d 28 b0 10 80    	mov    0x8010b028,%ecx
8010413e:	85 c9                	test   %ecx,%ecx
80104140:	78 2a                	js     8010416c <scheduler+0x39c>
						if(q1[u]->state == RUNNABLE){
80104142:	a1 40 3b 11 80       	mov    0x80113b40,%eax
80104147:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010414b:	0f 84 8f 00 00 00    	je     801041e0 <scheduler+0x410>
					for(int u=0;u<=c1;u++){
80104151:	31 c0                	xor    %eax,%eax
80104153:	eb 10                	jmp    80104165 <scheduler+0x395>
80104155:	8d 76 00             	lea    0x0(%esi),%esi
						if(q1[u]->state == RUNNABLE){
80104158:	8b 14 85 40 3b 11 80 	mov    -0x7feec4c0(,%eax,4),%edx
8010415f:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104163:	74 7b                	je     801041e0 <scheduler+0x410>
					for(int u=0;u<=c1;u++){
80104165:	83 c0 01             	add    $0x1,%eax
80104168:	39 c1                	cmp    %eax,%ecx
8010416a:	7d ec                	jge    80104158 <scheduler+0x388>
					for(int u=0;u<=c2;u++){
8010416c:	8b 0d 24 b0 10 80    	mov    0x8010b024,%ecx
80104172:	85 c9                	test   %ecx,%ecx
80104174:	78 26                	js     8010419c <scheduler+0x3cc>
						if(q2[u]->state == RUNNABLE){
80104176:	a1 40 39 11 80       	mov    0x80113940,%eax
8010417b:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010417f:	74 5f                	je     801041e0 <scheduler+0x410>
					for(int u=0;u<=c2;u++){
80104181:	31 c0                	xor    %eax,%eax
80104183:	eb 10                	jmp    80104195 <scheduler+0x3c5>
80104185:	8d 76 00             	lea    0x0(%esi),%esi
						if(q2[u]->state == RUNNABLE){
80104188:	8b 14 85 40 39 11 80 	mov    -0x7feec6c0(,%eax,4),%edx
8010418f:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104193:	74 4b                	je     801041e0 <scheduler+0x410>
					for(int u=0;u<=c2;u++){
80104195:	83 c0 01             	add    $0x1,%eax
80104198:	39 c1                	cmp    %eax,%ecx
8010419a:	7d ec                	jge    80104188 <scheduler+0x3b8>
						  if(q3[i]->state != RUNNABLE)
8010419c:	8b 3e                	mov    (%esi),%edi
8010419e:	8b 0d 20 b0 10 80    	mov    0x8010b020,%ecx
801041a4:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
801041a8:	0f 84 82 03 00 00    	je     80104530 <scheduler+0x760>
					for(i=0;i<=c3;i++){
801041ae:	83 c3 01             	add    $0x1,%ebx
801041b1:	39 cb                	cmp    %ecx,%ebx
801041b3:	0f 8f ec 03 00 00    	jg     801045a5 <scheduler+0x7d5>
						for(int u=0;u<=c0;u++){
801041b9:	8b 15 2c b0 10 80    	mov    0x8010b02c,%edx
801041bf:	83 c6 04             	add    $0x4,%esi
801041c2:	31 c9                	xor    %ecx,%ecx
801041c4:	85 d2                	test   %edx,%edx
801041c6:	0f 88 6c ff ff ff    	js     80104138 <scheduler+0x368>
801041cc:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
						if(q0[u]->state == RUNNABLE){
801041d2:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801041d6:	0f 85 24 ff ff ff    	jne    80104100 <scheduler+0x330>
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				if(c4!=-1){
801041e0:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
801041e5:	85 c0                	test   %eax,%eax
801041e7:	0f 88 43 01 00 00    	js     80104330 <scheduler+0x560>
							for(int u=0;u<=c0;u++){
801041ed:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
					for(i=0;i<=c4;i++){
801041f2:	31 db                	xor    %ebx,%ebx
							for(int u=0;u<=c0;u++){
801041f4:	b9 01 00 00 00       	mov    $0x1,%ecx
801041f9:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
801041ff:	85 c0                	test   %eax,%eax
80104201:	0f 88 29 01 00 00    	js     80104330 <scheduler+0x560>
						if(q0[u]->state == RUNNABLE){
80104207:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010420b:	0f 84 1f 01 00 00    	je     80104330 <scheduler+0x560>
80104211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
							for(int u=0;u<=c0;u++){
80104218:	8b 35 2c b0 10 80    	mov    0x8010b02c,%esi
8010421e:	31 c0                	xor    %eax,%eax
80104220:	eb 17                	jmp    80104239 <scheduler+0x469>
80104222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
						if(q0[u]->state == RUNNABLE){
80104228:	8b 14 85 40 3c 11 80 	mov    -0x7feec3c0(,%eax,4),%edx
8010422f:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104233:	0f 84 f7 00 00 00    	je     80104330 <scheduler+0x560>
							for(int u=0;u<=c0;u++){
80104239:	83 c0 01             	add    $0x1,%eax
8010423c:	39 c6                	cmp    %eax,%esi
8010423e:	7d e8                	jge    80104228 <scheduler+0x458>
					if(flag1==1){
80104240:	83 f9 01             	cmp    $0x1,%ecx
80104243:	0f 84 e7 00 00 00    	je     80104330 <scheduler+0x560>
80104249:	8d 34 9d 80 69 11 80 	lea    -0x7fee9680(,%ebx,4),%esi
					for(int u=0;u<=c1;u++){
80104250:	8b 0d 28 b0 10 80    	mov    0x8010b028,%ecx
80104256:	85 c9                	test   %ecx,%ecx
80104258:	78 2e                	js     80104288 <scheduler+0x4b8>
						if(q1[u]->state == RUNNABLE){
8010425a:	a1 40 3b 11 80       	mov    0x80113b40,%eax
8010425f:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104263:	0f 84 c7 00 00 00    	je     80104330 <scheduler+0x560>
					for(int u=0;u<=c1;u++){
80104269:	31 c0                	xor    %eax,%eax
8010426b:	eb 14                	jmp    80104281 <scheduler+0x4b1>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
						if(q1[u]->state == RUNNABLE){
80104270:	8b 14 85 40 3b 11 80 	mov    -0x7feec4c0(,%eax,4),%edx
80104277:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010427b:	0f 84 af 00 00 00    	je     80104330 <scheduler+0x560>
					for(int u=0;u<=c1;u++){
80104281:	83 c0 01             	add    $0x1,%eax
80104284:	39 c8                	cmp    %ecx,%eax
80104286:	7e e8                	jle    80104270 <scheduler+0x4a0>
					for(int u=0;u<=c2;u++){
80104288:	8b 0d 24 b0 10 80    	mov    0x8010b024,%ecx
8010428e:	85 c9                	test   %ecx,%ecx
80104290:	78 2a                	js     801042bc <scheduler+0x4ec>
						if(q2[u]->state == RUNNABLE){
80104292:	a1 40 39 11 80       	mov    0x80113940,%eax
80104297:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010429b:	0f 84 8f 00 00 00    	je     80104330 <scheduler+0x560>
					for(int u=0;u<=c2;u++){
801042a1:	31 c0                	xor    %eax,%eax
801042a3:	eb 10                	jmp    801042b5 <scheduler+0x4e5>
801042a5:	8d 76 00             	lea    0x0(%esi),%esi
						if(q2[u]->state == RUNNABLE){
801042a8:	8b 14 85 40 39 11 80 	mov    -0x7feec6c0(,%eax,4),%edx
801042af:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801042b3:	74 7b                	je     80104330 <scheduler+0x560>
					for(int u=0;u<=c2;u++){
801042b5:	83 c0 01             	add    $0x1,%eax
801042b8:	39 c8                	cmp    %ecx,%eax
801042ba:	7e ec                	jle    801042a8 <scheduler+0x4d8>
					for(int u=0;u<=c3;u++){
801042bc:	8b 0d 20 b0 10 80    	mov    0x8010b020,%ecx
801042c2:	85 c9                	test   %ecx,%ecx
801042c4:	78 26                	js     801042ec <scheduler+0x51c>
						if(q3[u]->state == RUNNABLE){
801042c6:	a1 40 3a 11 80       	mov    0x80113a40,%eax
801042cb:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042cf:	74 5f                	je     80104330 <scheduler+0x560>
					for(int u=0;u<=c3;u++){
801042d1:	31 c0                	xor    %eax,%eax
801042d3:	eb 10                	jmp    801042e5 <scheduler+0x515>
801042d5:	8d 76 00             	lea    0x0(%esi),%esi
						if(q3[u]->state == RUNNABLE){
801042d8:	8b 14 85 40 3a 11 80 	mov    -0x7feec5c0(,%eax,4),%edx
801042df:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801042e3:	74 4b                	je     80104330 <scheduler+0x560>
					for(int u=0;u<=c3;u++){
801042e5:	83 c0 01             	add    $0x1,%eax
801042e8:	39 c1                	cmp    %eax,%ecx
801042ea:	7d ec                	jge    801042d8 <scheduler+0x508>
						  if(q4[i]->state != RUNNABLE)
801042ec:	8b 3e                	mov    (%esi),%edi
801042ee:	8b 15 1c b0 10 80    	mov    0x8010b01c,%edx
801042f4:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
801042f8:	0f 84 42 03 00 00    	je     80104640 <scheduler+0x870>
					for(i=0;i<=c4;i++){
801042fe:	83 c3 01             	add    $0x1,%ebx
80104301:	39 d3                	cmp    %edx,%ebx
80104303:	7f 2b                	jg     80104330 <scheduler+0x560>
							for(int u=0;u<=c0;u++){
80104305:	8b 15 2c b0 10 80    	mov    0x8010b02c,%edx
8010430b:	83 c6 04             	add    $0x4,%esi
8010430e:	31 c9                	xor    %ecx,%ecx
80104310:	85 d2                	test   %edx,%edx
80104312:	0f 88 38 ff ff ff    	js     80104250 <scheduler+0x480>
80104318:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
						if(q0[u]->state == RUNNABLE){
8010431e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104322:	0f 85 f0 fe ff ff    	jne    80104218 <scheduler+0x448>
80104328:	90                   	nop
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	68 40 3d 11 80       	push   $0x80113d40
80104338:	e8 63 11 00 00       	call   801054a0 <release>
  for(;;){
8010433d:	83 c4 10             	add    $0x10,%esp
80104340:	e9 b3 fa ff ff       	jmp    80103df8 <scheduler+0x28>
80104345:	8d 76 00             	lea    0x0(%esi),%esi
            	for(int y=0;y<=c3;y++){
80104348:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010434b:	85 c9                	test   %ecx,%ecx
8010434d:	78 78                	js     801043c7 <scheduler+0x5f7>
            		if(q3[y]->pid==ptable.proc[j].pid){
8010434f:	8b 78 10             	mov    0x10(%eax),%edi
            	for(int y=0;y<=c3;y++){
80104352:	31 db                	xor    %ebx,%ebx
80104354:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104357:	eb 0e                	jmp    80104367 <scheduler+0x597>
80104359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104360:	83 c3 01             	add    $0x1,%ebx
80104363:	39 cb                	cmp    %ecx,%ebx
80104365:	7f 5a                	jg     801043c1 <scheduler+0x5f1>
            		if(q3[y]->pid==ptable.proc[j].pid){
80104367:	8b 14 9d 40 3a 11 80 	mov    -0x7feec5c0(,%ebx,4),%edx
8010436e:	39 7a 10             	cmp    %edi,0x10(%edx)
80104371:	75 ed                	jne    80104360 <scheduler+0x590>
					  for(z=y;z<=c3-1;z++)
80104373:	39 cb                	cmp    %ecx,%ebx
            			 q3[y]=NULL;
80104375:	c7 04 9d 40 3a 11 80 	movl   $0x0,-0x7feec5c0(,%ebx,4)
8010437c:	00 00 00 00 
					  for(z=y;z<=c3-1;z++)
80104380:	7d 26                	jge    801043a8 <scheduler+0x5d8>
80104382:	8d 14 9d 40 3a 11 80 	lea    -0x7feec5c0(,%ebx,4),%edx
80104389:	8d 34 8d 40 3a 11 80 	lea    -0x7feec5c0(,%ecx,4),%esi
80104390:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					  q3[z] = q3[z+1];
80104398:	8b 42 04             	mov    0x4(%edx),%eax
8010439b:	83 c2 04             	add    $0x4,%edx
8010439e:	89 42 fc             	mov    %eax,-0x4(%edx)
					  for(z=y;z<=c3-1;z++)
801043a1:	39 f2                	cmp    %esi,%edx
801043a3:	75 f3                	jne    80104398 <scheduler+0x5c8>
801043a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
					  q3[c3] = NULL;
801043a8:	c7 04 8d 40 3a 11 80 	movl   $0x0,-0x7feec5c0(,%ecx,4)
801043af:	00 00 00 00 
            	for(int y=0;y<=c3;y++){
801043b3:	83 c3 01             	add    $0x1,%ebx
					  c3--;
801043b6:	83 e9 01             	sub    $0x1,%ecx
            	for(int y=0;y<=c3;y++){
801043b9:	39 cb                	cmp    %ecx,%ebx
					  c3--;
801043bb:	c6 45 c8 01          	movb   $0x1,-0x38(%ebp)
            	for(int y=0;y<=c3;y++){
801043bf:	7e a6                	jle    80104367 <scheduler+0x597>
801043c1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801043c4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
            	c2++;
801043c7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            ptable.proc[j].current_queue--;
801043cb:	83 ea 01             	sub    $0x1,%edx
            	q2[c2]=&ptable.proc[j];
801043ce:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
            	c2++;
801043d2:	8b 7d e0             	mov    -0x20(%ebp),%edi
            ptable.proc[j].current_queue--;
801043d5:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
            	q2[c2]=&ptable.proc[j];
801043db:	89 04 bd 40 39 11 80 	mov    %eax,-0x7feec6c0(,%edi,4)
801043e2:	e9 71 fb ff ff       	jmp    80103f58 <scheduler+0x188>
801043e7:	89 f6                	mov    %esi,%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            	for(int y=0;y<=c2;y++){
801043f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801043f3:	85 c9                	test   %ecx,%ecx
801043f5:	78 78                	js     8010446f <scheduler+0x69f>
            		if(q2[y]->pid==ptable.proc[j].pid){
801043f7:	8b 78 10             	mov    0x10(%eax),%edi
            	for(int y=0;y<=c2;y++){
801043fa:	31 db                	xor    %ebx,%ebx
801043fc:	89 55 cc             	mov    %edx,-0x34(%ebp)
801043ff:	eb 0e                	jmp    8010440f <scheduler+0x63f>
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104408:	83 c3 01             	add    $0x1,%ebx
8010440b:	39 cb                	cmp    %ecx,%ebx
8010440d:	7f 5a                	jg     80104469 <scheduler+0x699>
            		if(q2[y]->pid==ptable.proc[j].pid){
8010440f:	8b 14 9d 40 39 11 80 	mov    -0x7feec6c0(,%ebx,4),%edx
80104416:	39 7a 10             	cmp    %edi,0x10(%edx)
80104419:	75 ed                	jne    80104408 <scheduler+0x638>
					  for(z=y;z<=c2-1;z++)
8010441b:	39 d9                	cmp    %ebx,%ecx
            			 q2[y]=NULL;
8010441d:	c7 04 9d 40 39 11 80 	movl   $0x0,-0x7feec6c0(,%ebx,4)
80104424:	00 00 00 00 
					  for(z=y;z<=c2-1;z++)
80104428:	7e 26                	jle    80104450 <scheduler+0x680>
8010442a:	8d 14 9d 40 39 11 80 	lea    -0x7feec6c0(,%ebx,4),%edx
80104431:	8d 34 8d 40 39 11 80 	lea    -0x7feec6c0(,%ecx,4),%esi
80104438:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010443b:	90                   	nop
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					  q2[z] = q2[z+1];
80104440:	8b 42 04             	mov    0x4(%edx),%eax
80104443:	83 c2 04             	add    $0x4,%edx
80104446:	89 42 fc             	mov    %eax,-0x4(%edx)
					  for(z=y;z<=c2-1;z++)
80104449:	39 f2                	cmp    %esi,%edx
8010444b:	75 f3                	jne    80104440 <scheduler+0x670>
8010444d:	8b 45 e0             	mov    -0x20(%ebp),%eax
					  q2[c2] = NULL;
80104450:	c7 04 8d 40 39 11 80 	movl   $0x0,-0x7feec6c0(,%ecx,4)
80104457:	00 00 00 00 
            	for(int y=0;y<=c2;y++){
8010445b:	83 c3 01             	add    $0x1,%ebx
					  c2--;
8010445e:	83 e9 01             	sub    $0x1,%ecx
            	for(int y=0;y<=c2;y++){
80104461:	39 cb                	cmp    %ecx,%ebx
					  c2--;
80104463:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
            	for(int y=0;y<=c2;y++){
80104467:	7e a6                	jle    8010440f <scheduler+0x63f>
80104469:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010446c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            	c1++;
8010446f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
            ptable.proc[j].current_queue--;
80104473:	83 ea 01             	sub    $0x1,%edx
            	q1[c1]=&ptable.proc[j];
80104476:	c6 45 cc 01          	movb   $0x1,-0x34(%ebp)
            	c1++;
8010447a:	8b 7d dc             	mov    -0x24(%ebp),%edi
            ptable.proc[j].current_queue--;
8010447d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
            	q1[c1]=&ptable.proc[j];
80104483:	89 04 bd 40 3b 11 80 	mov    %eax,-0x7feec4c0(,%edi,4)
8010448a:	e9 c9 fa ff ff       	jmp    80103f58 <scheduler+0x188>
8010448f:	90                   	nop
            	for(int y=0;y<=c1;y++){
80104490:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104493:	85 c9                	test   %ecx,%ecx
80104495:	78 78                	js     8010450f <scheduler+0x73f>
            		if(q1[y]->pid==ptable.proc[j].pid){
80104497:	8b 78 10             	mov    0x10(%eax),%edi
            	for(int y=0;y<=c1;y++){
8010449a:	31 db                	xor    %ebx,%ebx
8010449c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
8010449f:	eb 0e                	jmp    801044af <scheduler+0x6df>
801044a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044a8:	83 c3 01             	add    $0x1,%ebx
801044ab:	39 d9                	cmp    %ebx,%ecx
801044ad:	7c 5a                	jl     80104509 <scheduler+0x739>
            		if(q1[y]->pid==ptable.proc[j].pid){
801044af:	8b 14 9d 40 3b 11 80 	mov    -0x7feec4c0(,%ebx,4),%edx
801044b6:	39 7a 10             	cmp    %edi,0x10(%edx)
801044b9:	75 ed                	jne    801044a8 <scheduler+0x6d8>
					  for(z=y;z<=c1-1;z++)
801044bb:	39 d9                	cmp    %ebx,%ecx
            			 q1[y]=NULL;
801044bd:	c7 04 9d 40 3b 11 80 	movl   $0x0,-0x7feec4c0(,%ebx,4)
801044c4:	00 00 00 00 
					  for(z=y;z<=c1-1;z++)
801044c8:	7e 26                	jle    801044f0 <scheduler+0x720>
801044ca:	8d 14 9d 40 3b 11 80 	lea    -0x7feec4c0(,%ebx,4),%edx
801044d1:	8d 34 8d 40 3b 11 80 	lea    -0x7feec4c0(,%ecx,4),%esi
801044d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					  q1[z] = q1[z+1];
801044e0:	8b 42 04             	mov    0x4(%edx),%eax
801044e3:	83 c2 04             	add    $0x4,%edx
801044e6:	89 42 fc             	mov    %eax,-0x4(%edx)
					  for(z=y;z<=c1-1;z++)
801044e9:	39 f2                	cmp    %esi,%edx
801044eb:	75 f3                	jne    801044e0 <scheduler+0x710>
801044ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
					  q1[c1] = NULL;
801044f0:	c7 04 8d 40 3b 11 80 	movl   $0x0,-0x7feec4c0(,%ecx,4)
801044f7:	00 00 00 00 
            	for(int y=0;y<=c1;y++){
801044fb:	83 c3 01             	add    $0x1,%ebx
					  c1--;
801044fe:	83 e9 01             	sub    $0x1,%ecx
            	for(int y=0;y<=c1;y++){
80104501:	39 d9                	cmp    %ebx,%ecx
					  c1--;
80104503:	c6 45 cc 01          	movb   $0x1,-0x34(%ebp)
            	for(int y=0;y<=c1;y++){
80104507:	7d a6                	jge    801044af <scheduler+0x6df>
80104509:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010450c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
            	c0++;
8010450f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
            ptable.proc[j].current_queue--;
80104513:	83 ea 01             	sub    $0x1,%edx
            	q0[c0]=&ptable.proc[j];
80104516:	c6 45 b4 01          	movb   $0x1,-0x4c(%ebp)
            	c0++;
8010451a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
            ptable.proc[j].current_queue--;
8010451d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
            	q0[c0]=&ptable.proc[j];
80104523:	89 04 bd 40 3c 11 80 	mov    %eax,-0x7feec3c0(,%edi,4)
8010452a:	e9 29 fa ff ff       	jmp    80103f58 <scheduler+0x188>
8010452f:	90                   	nop
						  c->proc = q3[i];
80104530:	8b 45 d0             	mov    -0x30(%ebp),%eax
						  switchuvm(p);
80104533:	83 ec 0c             	sub    $0xc,%esp
						  c->proc = q3[i];
80104536:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
					  	  p->lastexperiencedtick = xticks;
8010453c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010453f:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
						  switchuvm(p);
80104545:	57                   	push   %edi
80104546:	e8 95 34 00 00       	call   801079e0 <switchuvm>
						  p->state = RUNNING;
8010454b:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
					      swtch(&(c->scheduler), p->context);
80104552:	59                   	pop    %ecx
80104553:	58                   	pop    %eax
80104554:	ff 77 1c             	pushl  0x1c(%edi)
80104557:	ff 75 bc             	pushl  -0x44(%ebp)
8010455a:	e8 cc 11 00 00       	call   8010572b <swtch>
						  switchkvm();
8010455f:	e8 5c 34 00 00       	call   801079c0 <switchkvm>
						  if(p->ticks[3]!=0 && p->ticks[3]%(clkPerPrio[3]*10)==0){
80104564:	8b 87 9c 00 00 00    	mov    0x9c(%edi),%eax
8010456a:	83 c4 10             	add    $0x10,%esp
8010456d:	8b 0d 20 b0 10 80    	mov    0x8010b020,%ecx
80104573:	85 c0                	test   %eax,%eax
80104575:	74 16                	je     8010458d <scheduler+0x7bd>
80104577:	8b 15 14 b0 10 80    	mov    0x8010b014,%edx
8010457d:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80104580:	99                   	cltd   
80104581:	01 ff                	add    %edi,%edi
80104583:	f7 ff                	idiv   %edi
80104585:	85 d2                	test   %edx,%edx
80104587:	0f 84 cd 02 00 00    	je     8010485a <scheduler+0xa8a>
						  c->proc = 0;
8010458d:	8b 45 d0             	mov    -0x30(%ebp),%eax
					for(i=0;i<=c3;i++){
80104590:	83 c3 01             	add    $0x1,%ebx
80104593:	39 cb                	cmp    %ecx,%ebx
						  c->proc = 0;
80104595:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010459c:	00 00 00 
					for(i=0;i<=c3;i++){
8010459f:	0f 8e 14 fc ff ff    	jle    801041b9 <scheduler+0x3e9>
				if(c4!=-1){
801045a5:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
801045aa:	85 c0                	test   %eax,%eax
801045ac:	0f 88 7e fd ff ff    	js     80104330 <scheduler+0x560>
							for(int u=0;u<=c0;u++){
801045b2:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
					for(i=0;i<=c4;i++){
801045b7:	31 db                	xor    %ebx,%ebx
							for(int u=0;u<=c0;u++){
801045b9:	31 c9                	xor    %ecx,%ecx
801045bb:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
801045c1:	85 c0                	test   %eax,%eax
801045c3:	0f 89 3e fc ff ff    	jns    80104207 <scheduler+0x437>
801045c9:	e9 7b fc ff ff       	jmp    80104249 <scheduler+0x479>
801045ce:	66 90                	xchg   %ax,%ax
					  p->lastexperiencedtick = xticks;
801045d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
					  switchuvm(p);
801045d3:	83 ec 0c             	sub    $0xc,%esp
					  c->proc = q1[i];
801045d6:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
					  p->lastexperiencedtick = xticks;
801045dc:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
					  switchuvm(p);
801045e2:	57                   	push   %edi
801045e3:	e8 f8 33 00 00       	call   801079e0 <switchuvm>
					  p->num_run++;
801045e8:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
					  p->state = RUNNING;
801045ef:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
					  swtch(&(c->scheduler), p->context);
801045f6:	58                   	pop    %eax
801045f7:	5a                   	pop    %edx
801045f8:	ff 77 1c             	pushl  0x1c(%edi)
801045fb:	ff 75 bc             	pushl  -0x44(%ebp)
801045fe:	e8 28 11 00 00       	call   8010572b <swtch>
					  switchkvm();
80104603:	e8 b8 33 00 00       	call   801079c0 <switchkvm>
					  if(p->ticks[1]!=0 && p->ticks[1]%(clkPerPrio[1]*10) == 0 ){
80104608:	8b 87 94 00 00 00    	mov    0x94(%edi),%eax
8010460e:	83 c4 10             	add    $0x10,%esp
80104611:	8b 0d 28 b0 10 80    	mov    0x8010b028,%ecx
80104617:	85 c0                	test   %eax,%eax
80104619:	74 16                	je     80104631 <scheduler+0x861>
8010461b:	8b 15 0c b0 10 80    	mov    0x8010b00c,%edx
80104621:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80104624:	99                   	cltd   
80104625:	01 ff                	add    %edi,%edi
80104627:	f7 ff                	idiv   %edi
80104629:	85 d2                	test   %edx,%edx
8010462b:	0f 84 05 03 00 00    	je     80104936 <scheduler+0xb66>
					  c->proc = 0;
80104631:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104638:	00 00 00 
8010463b:	e9 7f fa ff ff       	jmp    801040bf <scheduler+0x2ef>
						  c->proc = q4[i];
80104640:	8b 45 d0             	mov    -0x30(%ebp),%eax
						  p->lastexperiencedtick = xticks;
80104643:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
						  switchuvm(p);
80104646:	83 ec 0c             	sub    $0xc,%esp
						  c->proc = q4[i];
80104649:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
						  p->lastexperiencedtick = xticks;
8010464f:	89 8f ac 00 00 00    	mov    %ecx,0xac(%edi)
						  switchuvm(p);
80104655:	57                   	push   %edi
80104656:	e8 85 33 00 00       	call   801079e0 <switchuvm>
						  swtch(&(c->scheduler), c->proc->context);
8010465b:	8b 45 d0             	mov    -0x30(%ebp),%eax
					  		p->num_run++;
8010465e:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
						  p->state = RUNNING;
80104665:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
						  swtch(&(c->scheduler), c->proc->context);
8010466c:	59                   	pop    %ecx
8010466d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104673:	5f                   	pop    %edi
80104674:	ff 70 1c             	pushl  0x1c(%eax)
80104677:	ff 75 bc             	pushl  -0x44(%ebp)
8010467a:	e8 ac 10 00 00       	call   8010572b <swtch>
						  switchkvm();
8010467f:	e8 3c 33 00 00       	call   801079c0 <switchkvm>
						  for(j=i;j<=c4-1;j++)
80104684:	8b 15 1c b0 10 80    	mov    0x8010b01c,%edx
8010468a:	83 c4 10             	add    $0x10,%esp
						  q4[i]=NULL;
8010468d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
						  for(j=i;j<=c4-1;j++)
80104693:	39 da                	cmp    %ebx,%edx
80104695:	7e 16                	jle    801046ad <scheduler+0x8dd>
80104697:	8d 3c 95 80 69 11 80 	lea    -0x7fee9680(,%edx,4),%edi
8010469e:	89 f0                	mov    %esi,%eax
						  q4[j] = q4[j+1];
801046a0:	8b 48 04             	mov    0x4(%eax),%ecx
801046a3:	83 c0 04             	add    $0x4,%eax
801046a6:	89 48 fc             	mov    %ecx,-0x4(%eax)
						  for(j=i;j<=c4-1;j++)
801046a9:	39 c7                	cmp    %eax,%edi
801046ab:	75 f3                	jne    801046a0 <scheduler+0x8d0>
						  q4[c4] = c->proc;
801046ad:	8b 7d d0             	mov    -0x30(%ebp),%edi
801046b0:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
801046b6:	89 04 95 80 69 11 80 	mov    %eax,-0x7fee9680(,%edx,4)
						  c->proc = 0;
801046bd:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801046c4:	00 00 00 
801046c7:	e9 32 fc ff ff       	jmp    801042fe <scheduler+0x52e>
						for(int u=0;u<=c0;u++){
801046cc:	8b 35 2c b0 10 80    	mov    0x8010b02c,%esi
    int flag1=0;
801046d2:	31 c9                	xor    %ecx,%ecx
					for(i=0;i<=c2;i++){
801046d4:	31 db                	xor    %ebx,%ebx
801046d6:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
						for(int u=0;u<=c0;u++){
801046dc:	85 f6                	test   %esi,%esi
801046de:	78 3d                	js     8010471d <scheduler+0x94d>
						if(q0[u]->state == RUNNABLE){
801046e0:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801046e4:	0f 84 a6 00 00 00    	je     80104790 <scheduler+0x9c0>
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
						for(int u=0;u<=c0;u++){
801046f0:	8b 35 2c b0 10 80    	mov    0x8010b02c,%esi
801046f6:	31 c0                	xor    %eax,%eax
801046f8:	eb 17                	jmp    80104711 <scheduler+0x941>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
						if(q0[u]->state == RUNNABLE){
80104700:	8b 14 85 40 3c 11 80 	mov    -0x7feec3c0(,%eax,4),%edx
80104707:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010470b:	0f 84 7f 00 00 00    	je     80104790 <scheduler+0x9c0>
						for(int u=0;u<=c0;u++){
80104711:	83 c0 01             	add    $0x1,%eax
80104714:	39 c6                	cmp    %eax,%esi
80104716:	7d e8                	jge    80104700 <scheduler+0x930>
					if(flag1==1){
80104718:	83 f9 01             	cmp    $0x1,%ecx
8010471b:	74 73                	je     80104790 <scheduler+0x9c0>
8010471d:	8d 34 9d 40 39 11 80 	lea    -0x7feec6c0(,%ebx,4),%esi
					for(int u=0;u<=c1;u++){
80104724:	8b 0d 28 b0 10 80    	mov    0x8010b028,%ecx
8010472a:	85 c9                	test   %ecx,%ecx
8010472c:	78 26                	js     80104754 <scheduler+0x984>
						if(q1[u]->state == RUNNABLE){
8010472e:	a1 40 3b 11 80       	mov    0x80113b40,%eax
80104733:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104737:	74 57                	je     80104790 <scheduler+0x9c0>
					for(int u=0;u<=c1;u++){
80104739:	31 c0                	xor    %eax,%eax
8010473b:	eb 10                	jmp    8010474d <scheduler+0x97d>
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
						if(q1[u]->state == RUNNABLE){
80104740:	8b 14 85 40 3b 11 80 	mov    -0x7feec4c0(,%eax,4),%edx
80104747:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010474b:	74 43                	je     80104790 <scheduler+0x9c0>
					for(int u=0;u<=c1;u++){
8010474d:	83 c0 01             	add    $0x1,%eax
80104750:	39 c8                	cmp    %ecx,%eax
80104752:	7e ec                	jle    80104740 <scheduler+0x970>
						  if(q2[i]->state != RUNNABLE)
80104754:	8b 3e                	mov    (%esi),%edi
80104756:	8b 0d 24 b0 10 80    	mov    0x8010b024,%ecx
8010475c:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80104760:	74 5e                	je     801047c0 <scheduler+0x9f0>
					for(i=0;i<=c2;i++){
80104762:	83 c3 01             	add    $0x1,%ebx
80104765:	39 cb                	cmp    %ecx,%ebx
80104767:	0f 8f 67 f9 ff ff    	jg     801040d4 <scheduler+0x304>
						for(int u=0;u<=c0;u++){
8010476d:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
80104772:	83 c6 04             	add    $0x4,%esi
80104775:	31 c9                	xor    %ecx,%ecx
80104777:	85 c0                	test   %eax,%eax
80104779:	78 a9                	js     80104724 <scheduler+0x954>
8010477b:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
						if(q0[u]->state == RUNNABLE){
80104781:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104785:	0f 85 65 ff ff ff    	jne    801046f0 <scheduler+0x920>
8010478b:	90                   	nop
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				if(c3!=-1){
80104790:	8b 0d 20 b0 10 80    	mov    0x8010b020,%ecx
80104796:	85 c9                	test   %ecx,%ecx
80104798:	0f 88 42 fa ff ff    	js     801041e0 <scheduler+0x410>
						for(int u=0;u<=c0;u++){
8010479e:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
					for(i=0;i<=c3;i++){
801047a3:	31 db                	xor    %ebx,%ebx
						for(int u=0;u<=c0;u++){
801047a5:	b9 01 00 00 00       	mov    $0x1,%ecx
801047aa:	8b 15 40 3c 11 80    	mov    0x80113c40,%edx
801047b0:	85 c0                	test   %eax,%eax
801047b2:	0f 89 3c f9 ff ff    	jns    801040f4 <scheduler+0x324>
801047b8:	e9 23 fa ff ff       	jmp    801041e0 <scheduler+0x410>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
						  c->proc = q2[i];
801047c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
						  switchuvm(p);
801047c3:	83 ec 0c             	sub    $0xc,%esp
						  c->proc = q2[i];
801047c6:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
						  p->lastexperiencedtick = xticks;
801047cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047cf:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
						  switchuvm(p);
801047d5:	57                   	push   %edi
801047d6:	e8 05 32 00 00       	call   801079e0 <switchuvm>
					  		p->num_run++;
801047db:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
						  p->state = RUNNING;
801047e2:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
					      swtch(&(c->scheduler), p->context);
801047e9:	58                   	pop    %eax
801047ea:	5a                   	pop    %edx
801047eb:	ff 77 1c             	pushl  0x1c(%edi)
801047ee:	ff 75 bc             	pushl  -0x44(%ebp)
801047f1:	e8 35 0f 00 00       	call   8010572b <swtch>
						  switchkvm();
801047f6:	e8 c5 31 00 00       	call   801079c0 <switchkvm>
						  if(p->ticks[2]!=0 && p->ticks[2]%(clkPerPrio[2]*10)==0){
801047fb:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
80104801:	83 c4 10             	add    $0x10,%esp
80104804:	8b 0d 24 b0 10 80    	mov    0x8010b024,%ecx
8010480a:	85 c0                	test   %eax,%eax
8010480c:	74 16                	je     80104824 <scheduler+0xa54>
8010480e:	8b 15 10 b0 10 80    	mov    0x8010b010,%edx
80104814:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80104817:	99                   	cltd   
80104818:	01 ff                	add    %edi,%edi
8010481a:	f7 ff                	idiv   %edi
8010481c:	85 d2                	test   %edx,%edx
8010481e:	0f 84 a2 00 00 00    	je     801048c6 <scheduler+0xaf6>
						  c->proc = 0;
80104824:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104827:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010482e:	00 00 00 
80104831:	e9 2c ff ff ff       	jmp    80104762 <scheduler+0x992>
80104836:	8d 76 00             	lea    0x0(%esi),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
				if(c2!=-1){
80104840:	8b 1d 24 b0 10 80    	mov    0x8010b024,%ebx
80104846:	85 db                	test   %ebx,%ebx
80104848:	0f 88 c8 01 00 00    	js     80104a16 <scheduler+0xc46>
8010484e:	b9 01 00 00 00       	mov    $0x1,%ecx
					for(i=0;i<=c2;i++){
80104853:	31 db                	xor    %ebx,%ebx
80104855:	e9 86 fe ff ff       	jmp    801046e0 <scheduler+0x910>
						  c->proc->current_queue=4;
8010485a:	8b 7d d0             	mov    -0x30(%ebp),%edi
						  c4++;
8010485d:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
						  c->proc->current_queue=4;
80104862:	8b 97 ac 00 00 00    	mov    0xac(%edi),%edx
						  c4++;
80104868:	83 c0 01             	add    $0x1,%eax
						  for(j=i;j<=c3-1;j++)
8010486b:	39 cb                	cmp    %ecx,%ebx
						  c4++;
8010486d:	a3 1c b0 10 80       	mov    %eax,0x8010b01c
						  c->proc->current_queue=4;
80104872:	c7 82 a4 00 00 00 04 	movl   $0x4,0xa4(%edx)
80104879:	00 00 00 
						  q4[c4] = c->proc;
8010487c:	8b 97 ac 00 00 00    	mov    0xac(%edi),%edx
						  q3[i]=NULL;
80104882:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
						  q4[c4] = c->proc;
80104888:	89 14 85 80 69 11 80 	mov    %edx,-0x7fee9680(,%eax,4)
						  for(j=i;j<=c3-1;j++)
8010488f:	7d 1c                	jge    801048ad <scheduler+0xadd>
80104891:	8d 3c 8d 40 3a 11 80 	lea    -0x7feec5c0(,%ecx,4),%edi
80104898:	89 f0                	mov    %esi,%eax
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
						  q3[j] = q3[j+1];
801048a0:	8b 50 04             	mov    0x4(%eax),%edx
801048a3:	83 c0 04             	add    $0x4,%eax
801048a6:	89 50 fc             	mov    %edx,-0x4(%eax)
						  for(j=i;j<=c3-1;j++)
801048a9:	39 c7                	cmp    %eax,%edi
801048ab:	75 f3                	jne    801048a0 <scheduler+0xad0>
						  q3[c3] =NULL;
801048ad:	c7 04 8d 40 3a 11 80 	movl   $0x0,-0x7feec5c0(,%ecx,4)
801048b4:	00 00 00 00 
						  c3--;
801048b8:	83 e9 01             	sub    $0x1,%ecx
801048bb:	89 0d 20 b0 10 80    	mov    %ecx,0x8010b020
801048c1:	e9 c7 fc ff ff       	jmp    8010458d <scheduler+0x7bd>
						  c->proc->current_queue=3;
801048c6:	8b 7d d0             	mov    -0x30(%ebp),%edi
						  c3++;
801048c9:	a1 20 b0 10 80       	mov    0x8010b020,%eax
						  c->proc->current_queue=3;
801048ce:	8b 97 ac 00 00 00    	mov    0xac(%edi),%edx
						  c3++;
801048d4:	83 c0 01             	add    $0x1,%eax
						  for(j=i;j<=c2-1;j++)
801048d7:	39 cb                	cmp    %ecx,%ebx
						  c3++;
801048d9:	a3 20 b0 10 80       	mov    %eax,0x8010b020
						  c->proc->current_queue=3;
801048de:	c7 82 a4 00 00 00 03 	movl   $0x3,0xa4(%edx)
801048e5:	00 00 00 
						  q3[c3] = c->proc;
801048e8:	8b 97 ac 00 00 00    	mov    0xac(%edi),%edx
						  q2[i]=NULL;
801048ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
						  q3[c3] = c->proc;
801048f4:	89 14 85 40 3a 11 80 	mov    %edx,-0x7feec5c0(,%eax,4)
						  for(j=i;j<=c2-1;j++)
801048fb:	7d 20                	jge    8010491d <scheduler+0xb4d>
801048fd:	8d 3c 8d 40 39 11 80 	lea    -0x7feec6c0(,%ecx,4),%edi
80104904:	89 f0                	mov    %esi,%eax
80104906:	8d 76 00             	lea    0x0(%esi),%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
						  q2[j] = q2[j+1];
80104910:	8b 50 04             	mov    0x4(%eax),%edx
80104913:	83 c0 04             	add    $0x4,%eax
80104916:	89 50 fc             	mov    %edx,-0x4(%eax)
						  for(j=i;j<=c2-1;j++)
80104919:	39 c7                	cmp    %eax,%edi
8010491b:	75 f3                	jne    80104910 <scheduler+0xb40>
						  q2[c2] =NULL;
8010491d:	c7 04 8d 40 39 11 80 	movl   $0x0,-0x7feec6c0(,%ecx,4)
80104924:	00 00 00 00 
						  c2--;
80104928:	83 e9 01             	sub    $0x1,%ecx
8010492b:	89 0d 24 b0 10 80    	mov    %ecx,0x8010b024
80104931:	e9 ee fe ff ff       	jmp    80104824 <scheduler+0xa54>
					  c->proc->current_queue=2;
80104936:	8b 96 ac 00 00 00    	mov    0xac(%esi),%edx
					  c2++;
8010493c:	a1 24 b0 10 80       	mov    0x8010b024,%eax
					  c->proc->current_queue=2;
80104941:	c7 82 a4 00 00 00 02 	movl   $0x2,0xa4(%edx)
80104948:	00 00 00 
					  q2[c2] = c->proc;
8010494b:	8b 96 ac 00 00 00    	mov    0xac(%esi),%edx
					  c2++;
80104951:	83 c0 01             	add    $0x1,%eax
					  for(j=i;j<=c1-1;j++)
80104954:	39 cb                	cmp    %ecx,%ebx
					  c2++;
80104956:	a3 24 b0 10 80       	mov    %eax,0x8010b024
					  q1[i]=NULL;
8010495b:	c7 04 9d 40 3b 11 80 	movl   $0x0,-0x7feec4c0(,%ebx,4)
80104962:	00 00 00 00 
					  q2[c2] = c->proc;
80104966:	89 14 85 40 39 11 80 	mov    %edx,-0x7feec6c0(,%eax,4)
					  for(j=i;j<=c1-1;j++)
8010496d:	7d 1e                	jge    8010498d <scheduler+0xbbd>
8010496f:	8d 04 9d 40 3b 11 80 	lea    -0x7feec4c0(,%ebx,4),%eax
80104976:	8d 3c 8d 40 3b 11 80 	lea    -0x7feec4c0(,%ecx,4),%edi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
					  q1[j] = q1[j+1];
80104980:	8b 50 04             	mov    0x4(%eax),%edx
80104983:	83 c0 04             	add    $0x4,%eax
80104986:	89 50 fc             	mov    %edx,-0x4(%eax)
					  for(j=i;j<=c1-1;j++)
80104989:	39 f8                	cmp    %edi,%eax
8010498b:	75 f3                	jne    80104980 <scheduler+0xbb0>
					  q1[c1] = NULL;
8010498d:	c7 04 8d 40 3b 11 80 	movl   $0x0,-0x7feec4c0(,%ecx,4)
80104994:	00 00 00 00 
					  c1--;
80104998:	83 e9 01             	sub    $0x1,%ecx
8010499b:	89 0d 28 b0 10 80    	mov    %ecx,0x8010b028
801049a1:	e9 8b fc ff ff       	jmp    80104631 <scheduler+0x861>
						  c->proc->current_queue=1;
801049a6:	8b 96 ac 00 00 00    	mov    0xac(%esi),%edx
						  c1++;
801049ac:	a1 28 b0 10 80       	mov    0x8010b028,%eax
						  c->proc->current_queue=1;
801049b1:	c7 82 a4 00 00 00 01 	movl   $0x1,0xa4(%edx)
801049b8:	00 00 00 
						  q1[c1] = c->proc;
801049bb:	8b 96 ac 00 00 00    	mov    0xac(%esi),%edx
						  c1++;
801049c1:	83 c0 01             	add    $0x1,%eax
						  for(j=i;j<=c0-1;j++)
801049c4:	39 cb                	cmp    %ecx,%ebx
						  c1++;
801049c6:	a3 28 b0 10 80       	mov    %eax,0x8010b028
						  q0[i]=NULL;
801049cb:	c7 04 9d 40 3c 11 80 	movl   $0x0,-0x7feec3c0(,%ebx,4)
801049d2:	00 00 00 00 
						  q1[c1] = c->proc;
801049d6:	89 14 85 40 3b 11 80 	mov    %edx,-0x7feec4c0(,%eax,4)
						  for(j=i;j<=c0-1;j++)
801049dd:	7d 1e                	jge    801049fd <scheduler+0xc2d>
801049df:	8d 04 9d 40 3c 11 80 	lea    -0x7feec3c0(,%ebx,4),%eax
801049e6:	8d 3c 8d 40 3c 11 80 	lea    -0x7feec3c0(,%ecx,4),%edi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
							  q0[j] = q0[j+1];
801049f0:	8b 50 04             	mov    0x4(%eax),%edx
801049f3:	83 c0 04             	add    $0x4,%eax
801049f6:	89 50 fc             	mov    %edx,-0x4(%eax)
						  for(j=i;j<=c0-1;j++)
801049f9:	39 f8                	cmp    %edi,%eax
801049fb:	75 f3                	jne    801049f0 <scheduler+0xc20>
						  q0[c0] = NULL;
801049fd:	c7 04 8d 40 3c 11 80 	movl   $0x0,-0x7feec3c0(,%ecx,4)
80104a04:	00 00 00 00 
						  c0--;
80104a08:	83 e9 01             	sub    $0x1,%ecx
80104a0b:	89 0d 2c b0 10 80    	mov    %ecx,0x8010b02c
80104a11:	e9 29 f6 ff ff       	jmp    8010403f <scheduler+0x26f>
				if(c3!=-1){
80104a16:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104a1b:	85 c0                	test   %eax,%eax
80104a1d:	79 39                	jns    80104a58 <scheduler+0xc88>
				if(c4!=-1){
80104a1f:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
80104a24:	85 c0                	test   %eax,%eax
80104a26:	0f 88 04 f9 ff ff    	js     80104330 <scheduler+0x560>
							for(int u=0;u<=c0;u++){
80104a2c:	a1 2c b0 10 80       	mov    0x8010b02c,%eax
					for(i=0;i<=c4;i++){
80104a31:	31 db                	xor    %ebx,%ebx
							for(int u=0;u<=c0;u++){
80104a33:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	0f 89 c7 f7 ff ff    	jns    80104207 <scheduler+0x437>
    release(&ptable.lock);
80104a40:	83 ec 0c             	sub    $0xc,%esp
80104a43:	68 40 3d 11 80       	push   $0x80113d40
80104a48:	e8 53 0a 00 00       	call   801054a0 <release>
  for(;;){
80104a4d:	83 c4 10             	add    $0x10,%esp
80104a50:	e9 a3 f3 ff ff       	jmp    80103df8 <scheduler+0x28>
80104a55:	8d 76 00             	lea    0x0(%esi),%esi
					for(i=0;i<=c3;i++){
80104a58:	31 db                	xor    %ebx,%ebx
				if(c3!=-1){
80104a5a:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a5f:	e9 90 f6 ff ff       	jmp    801040f4 <scheduler+0x324>
80104a64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104a67:	a3 2c b0 10 80       	mov    %eax,0x8010b02c
80104a6c:	e9 3b f5 ff ff       	jmp    80103fac <scheduler+0x1dc>
80104a71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a74:	a3 28 b0 10 80       	mov    %eax,0x8010b028
80104a79:	e9 f4 f4 ff ff       	jmp    80103f72 <scheduler+0x1a2>
80104a7e:	66 90                	xchg   %ax,%ax

80104a80 <sched>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  pushcli();
80104a85:	e8 86 08 00 00       	call   80105310 <pushcli>
  c = mycpu();
80104a8a:	e8 41 ed ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104a8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a95:	e8 b6 08 00 00       	call   80105350 <popcli>
  if(!holding(&ptable.lock))
80104a9a:	83 ec 0c             	sub    $0xc,%esp
80104a9d:	68 40 3d 11 80       	push   $0x80113d40
80104aa2:	e8 09 09 00 00       	call   801053b0 <holding>
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	74 4f                	je     80104afd <sched+0x7d>
  if(mycpu()->ncli != 1)
80104aae:	e8 1d ed ff ff       	call   801037d0 <mycpu>
80104ab3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104aba:	75 68                	jne    80104b24 <sched+0xa4>
  if(p->state == RUNNING)
80104abc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104ac0:	74 55                	je     80104b17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ac2:	9c                   	pushf  
80104ac3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ac4:	f6 c4 02             	test   $0x2,%ah
80104ac7:	75 41                	jne    80104b0a <sched+0x8a>
  intena = mycpu()->intena;
80104ac9:	e8 02 ed ff ff       	call   801037d0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104ace:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104ad1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104ad7:	e8 f4 ec ff ff       	call   801037d0 <mycpu>
80104adc:	83 ec 08             	sub    $0x8,%esp
80104adf:	ff 70 04             	pushl  0x4(%eax)
80104ae2:	53                   	push   %ebx
80104ae3:	e8 43 0c 00 00       	call   8010572b <swtch>
  mycpu()->intena = intena;
80104ae8:	e8 e3 ec ff ff       	call   801037d0 <mycpu>
}
80104aed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104af0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104af6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af9:	5b                   	pop    %ebx
80104afa:	5e                   	pop    %esi
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
    panic("sched ptable.lock");
80104afd:	83 ec 0c             	sub    $0xc,%esp
80104b00:	68 d5 86 10 80       	push   $0x801086d5
80104b05:	e8 86 b8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104b0a:	83 ec 0c             	sub    $0xc,%esp
80104b0d:	68 01 87 10 80       	push   $0x80108701
80104b12:	e8 79 b8 ff ff       	call   80100390 <panic>
    panic("sched running");
80104b17:	83 ec 0c             	sub    $0xc,%esp
80104b1a:	68 f3 86 10 80       	push   $0x801086f3
80104b1f:	e8 6c b8 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104b24:	83 ec 0c             	sub    $0xc,%esp
80104b27:	68 e7 86 10 80       	push   $0x801086e7
80104b2c:	e8 5f b8 ff ff       	call   80100390 <panic>
80104b31:	eb 0d                	jmp    80104b40 <exit>
80104b33:	90                   	nop
80104b34:	90                   	nop
80104b35:	90                   	nop
80104b36:	90                   	nop
80104b37:	90                   	nop
80104b38:	90                   	nop
80104b39:	90                   	nop
80104b3a:	90                   	nop
80104b3b:	90                   	nop
80104b3c:	90                   	nop
80104b3d:	90                   	nop
80104b3e:	90                   	nop
80104b3f:	90                   	nop

80104b40 <exit>:
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104b49:	e8 c2 07 00 00       	call   80105310 <pushcli>
  c = mycpu();
80104b4e:	e8 7d ec ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104b53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b59:	e8 f2 07 00 00       	call   80105350 <popcli>
  if(curproc == initproc)
80104b5e:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
80104b64:	8d 5e 28             	lea    0x28(%esi),%ebx
80104b67:	8d 7e 68             	lea    0x68(%esi),%edi
80104b6a:	0f 84 fc 00 00 00    	je     80104c6c <exit+0x12c>
    if(curproc->ofile[fd]){
80104b70:	8b 03                	mov    (%ebx),%eax
80104b72:	85 c0                	test   %eax,%eax
80104b74:	74 12                	je     80104b88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	50                   	push   %eax
80104b7a:	e8 c1 c2 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80104b7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80104b8b:	39 fb                	cmp    %edi,%ebx
80104b8d:	75 e1                	jne    80104b70 <exit+0x30>
  begin_op();
80104b8f:	e8 0c e0 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	ff 76 68             	pushl  0x68(%esi)
80104b9a:	e8 11 cc ff ff       	call   801017b0 <iput>
  end_op();
80104b9f:	e8 6c e0 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80104ba4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104bab:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104bb2:	e8 29 08 00 00       	call   801053e0 <acquire>
  wakeup1(curproc->parent);
80104bb7:	8b 56 14             	mov    0x14(%esi),%edx
80104bba:	83 c4 10             	add    $0x10,%esp
		// 			q4[i] = q4[i-1];
		// 		}
		// 		q4[0] = p;
		// 	}

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bbd:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104bc2:	eb 10                	jmp    80104bd4 <exit+0x94>
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	05 b0 00 00 00       	add    $0xb0,%eax
80104bcd:	3d 74 69 11 80       	cmp    $0x80116974,%eax
80104bd2:	73 1e                	jae    80104bf2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104bd4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bd8:	75 ee                	jne    80104bc8 <exit+0x88>
80104bda:	3b 50 20             	cmp    0x20(%eax),%edx
80104bdd:	75 e9                	jne    80104bc8 <exit+0x88>
      p->state = RUNNABLE;
80104bdf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be6:	05 b0 00 00 00       	add    $0xb0,%eax
80104beb:	3d 74 69 11 80       	cmp    $0x80116974,%eax
80104bf0:	72 e2                	jb     80104bd4 <exit+0x94>
      p->parent = initproc;
80104bf2:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf8:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
80104bfd:	eb 0f                	jmp    80104c0e <exit+0xce>
80104bff:	90                   	nop
80104c00:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80104c06:	81 fa 74 69 11 80    	cmp    $0x80116974,%edx
80104c0c:	73 3a                	jae    80104c48 <exit+0x108>
    if(p->parent == curproc){
80104c0e:	39 72 14             	cmp    %esi,0x14(%edx)
80104c11:	75 ed                	jne    80104c00 <exit+0xc0>
      if(p->state == ZOMBIE)
80104c13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104c17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104c1a:	75 e4                	jne    80104c00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c1c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104c21:	eb 11                	jmp    80104c34 <exit+0xf4>
80104c23:	90                   	nop
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c28:	05 b0 00 00 00       	add    $0xb0,%eax
80104c2d:	3d 74 69 11 80       	cmp    $0x80116974,%eax
80104c32:	73 cc                	jae    80104c00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104c34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104c38:	75 ee                	jne    80104c28 <exit+0xe8>
80104c3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104c3d:	75 e9                	jne    80104c28 <exit+0xe8>
      p->state = RUNNABLE;
80104c3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104c46:	eb e0                	jmp    80104c28 <exit+0xe8>
  curproc->etime = ticks; 
80104c48:	a1 c0 72 11 80       	mov    0x801172c0,%eax
  curproc->state = ZOMBIE;
80104c4d:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->etime = ticks; 
80104c54:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
  sched();
80104c5a:	e8 21 fe ff ff       	call   80104a80 <sched>
  panic("zombie exit");
80104c5f:	83 ec 0c             	sub    $0xc,%esp
80104c62:	68 22 87 10 80       	push   $0x80108722
80104c67:	e8 24 b7 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104c6c:	83 ec 0c             	sub    $0xc,%esp
80104c6f:	68 15 87 10 80       	push   $0x80108715
80104c74:	e8 17 b7 ff ff       	call   80100390 <panic>
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c80 <yield>:
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c87:	68 40 3d 11 80       	push   $0x80113d40
80104c8c:	e8 4f 07 00 00       	call   801053e0 <acquire>
  pushcli();
80104c91:	e8 7a 06 00 00       	call   80105310 <pushcli>
  c = mycpu();
80104c96:	e8 35 eb ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104c9b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ca1:	e8 aa 06 00 00       	call   80105350 <popcli>
  myproc()->state = RUNNABLE;
80104ca6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104cad:	e8 ce fd ff ff       	call   80104a80 <sched>
  release(&ptable.lock);
80104cb2:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104cb9:	e8 e2 07 00 00       	call   801054a0 <release>
}
80104cbe:	83 c4 10             	add    $0x10,%esp
80104cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc4:	c9                   	leave  
80104cc5:	c3                   	ret    
80104cc6:	8d 76 00             	lea    0x0(%esi),%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sleep>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	83 ec 0c             	sub    $0xc,%esp
80104cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104cdf:	e8 2c 06 00 00       	call   80105310 <pushcli>
  c = mycpu();
80104ce4:	e8 e7 ea ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104ce9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104cef:	e8 5c 06 00 00       	call   80105350 <popcli>
  if(p == 0)
80104cf4:	85 db                	test   %ebx,%ebx
80104cf6:	0f 84 87 00 00 00    	je     80104d83 <sleep+0xb3>
  if(lk == 0)
80104cfc:	85 f6                	test   %esi,%esi
80104cfe:	74 76                	je     80104d76 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104d00:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
80104d06:	74 50                	je     80104d58 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104d08:	83 ec 0c             	sub    $0xc,%esp
80104d0b:	68 40 3d 11 80       	push   $0x80113d40
80104d10:	e8 cb 06 00 00       	call   801053e0 <acquire>
    release(lk);
80104d15:	89 34 24             	mov    %esi,(%esp)
80104d18:	e8 83 07 00 00       	call   801054a0 <release>
  p->chan = chan;
80104d1d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104d20:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d27:	e8 54 fd ff ff       	call   80104a80 <sched>
  p->chan = 0;
80104d2c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104d33:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104d3a:	e8 61 07 00 00       	call   801054a0 <release>
    acquire(lk);
80104d3f:	89 75 08             	mov    %esi,0x8(%ebp)
80104d42:	83 c4 10             	add    $0x10,%esp
}
80104d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d48:	5b                   	pop    %ebx
80104d49:	5e                   	pop    %esi
80104d4a:	5f                   	pop    %edi
80104d4b:	5d                   	pop    %ebp
    acquire(lk);
80104d4c:	e9 8f 06 00 00       	jmp    801053e0 <acquire>
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104d58:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104d5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d62:	e8 19 fd ff ff       	call   80104a80 <sched>
  p->chan = 0;
80104d67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d71:	5b                   	pop    %ebx
80104d72:	5e                   	pop    %esi
80104d73:	5f                   	pop    %edi
80104d74:	5d                   	pop    %ebp
80104d75:	c3                   	ret    
    panic("sleep without lk");
80104d76:	83 ec 0c             	sub    $0xc,%esp
80104d79:	68 34 87 10 80       	push   $0x80108734
80104d7e:	e8 0d b6 ff ff       	call   80100390 <panic>
    panic("sleep");
80104d83:	83 ec 0c             	sub    $0xc,%esp
80104d86:	68 2e 87 10 80       	push   $0x8010872e
80104d8b:	e8 00 b6 ff ff       	call   80100390 <panic>

80104d90 <wait>:
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
  pushcli();
80104d95:	e8 76 05 00 00       	call   80105310 <pushcli>
  c = mycpu();
80104d9a:	e8 31 ea ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104d9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104da5:	e8 a6 05 00 00       	call   80105350 <popcli>
  acquire(&ptable.lock);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	68 40 3d 11 80       	push   $0x80113d40
80104db2:	e8 29 06 00 00       	call   801053e0 <acquire>
80104db7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104dba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dbc:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104dc1:	eb 13                	jmp    80104dd6 <wait+0x46>
80104dc3:	90                   	nop
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104dce:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80104dd4:	73 1e                	jae    80104df4 <wait+0x64>
      if(p->parent != curproc)
80104dd6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104dd9:	75 ed                	jne    80104dc8 <wait+0x38>
      if(p->state == ZOMBIE){
80104ddb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104ddf:	74 37                	je     80104e18 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104de1:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80104de7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dec:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80104df2:	72 e2                	jb     80104dd6 <wait+0x46>
    if(!havekids || curproc->killed){
80104df4:	85 c0                	test   %eax,%eax
80104df6:	74 76                	je     80104e6e <wait+0xde>
80104df8:	8b 46 24             	mov    0x24(%esi),%eax
80104dfb:	85 c0                	test   %eax,%eax
80104dfd:	75 6f                	jne    80104e6e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104dff:	83 ec 08             	sub    $0x8,%esp
80104e02:	68 40 3d 11 80       	push   $0x80113d40
80104e07:	56                   	push   %esi
80104e08:	e8 c3 fe ff ff       	call   80104cd0 <sleep>
    havekids = 0;
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	eb a8                	jmp    80104dba <wait+0x2a>
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104e1e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104e21:	e8 ea d4 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80104e26:	5a                   	pop    %edx
80104e27:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104e2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104e31:	e8 5a 2f 00 00       	call   80107d90 <freevm>
        release(&ptable.lock);
80104e36:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
80104e3d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104e44:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104e4b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104e4f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104e56:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104e5d:	e8 3e 06 00 00       	call   801054a0 <release>
        return pid;
80104e62:	83 c4 10             	add    $0x10,%esp
}
80104e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e68:	89 f0                	mov    %esi,%eax
80104e6a:	5b                   	pop    %ebx
80104e6b:	5e                   	pop    %esi
80104e6c:	5d                   	pop    %ebp
80104e6d:	c3                   	ret    
      release(&ptable.lock);
80104e6e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104e71:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104e76:	68 40 3d 11 80       	push   $0x80113d40
80104e7b:	e8 20 06 00 00       	call   801054a0 <release>
      return -1;
80104e80:	83 c4 10             	add    $0x10,%esp
80104e83:	eb e0                	jmp    80104e65 <wait+0xd5>
80104e85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <waitx>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  pushcli();
80104e95:	e8 76 04 00 00       	call   80105310 <pushcli>
  c = mycpu();
80104e9a:	e8 31 e9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104e9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104ea5:	e8 a6 04 00 00       	call   80105350 <popcli>
  acquire(&ptable.lock);
80104eaa:	83 ec 0c             	sub    $0xc,%esp
80104ead:	68 40 3d 11 80       	push   $0x80113d40
80104eb2:	e8 29 05 00 00       	call   801053e0 <acquire>
80104eb7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104eba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ebc:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104ec1:	eb 13                	jmp    80104ed6 <waitx+0x46>
80104ec3:	90                   	nop
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104ece:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80104ed4:	73 1e                	jae    80104ef4 <waitx+0x64>
      if(p->parent != curproc)
80104ed6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104ed9:	75 ed                	jne    80104ec8 <waitx+0x38>
      if(p->state == ZOMBIE){
80104edb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104edf:	74 3f                	je     80104f20 <waitx+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ee1:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80104ee7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eec:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
80104ef2:	72 e2                	jb     80104ed6 <waitx+0x46>
    if(!havekids || curproc->killed){
80104ef4:	85 c0                	test   %eax,%eax
80104ef6:	0f 84 9f 00 00 00    	je     80104f9b <waitx+0x10b>
80104efc:	8b 46 24             	mov    0x24(%esi),%eax
80104eff:	85 c0                	test   %eax,%eax
80104f01:	0f 85 94 00 00 00    	jne    80104f9b <waitx+0x10b>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104f07:	83 ec 08             	sub    $0x8,%esp
80104f0a:	68 40 3d 11 80       	push   $0x80113d40
80104f0f:	56                   	push   %esi
80104f10:	e8 bb fd ff ff       	call   80104cd0 <sleep>
    havekids = 0;
80104f15:	83 c4 10             	add    $0x10,%esp
80104f18:	eb a0                	jmp    80104eba <waitx+0x2a>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *wtime = p->etime - p->stime - p->rtime - p->iotime;
80104f20:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104f26:	2b 43 7c             	sub    0x7c(%ebx),%eax
        kfree(p->kstack);
80104f29:	83 ec 0c             	sub    $0xc,%esp
        *wtime = p->etime - p->stime - p->rtime - p->iotime;
80104f2c:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104f32:	8b 55 08             	mov    0x8(%ebp),%edx
80104f35:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80104f3b:	89 02                	mov    %eax,(%edx)
        *rtime = p->rtime;
80104f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f40:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104f46:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack);
80104f48:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104f4b:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104f4e:	e8 bd d3 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80104f53:	5a                   	pop    %edx
80104f54:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104f57:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104f5e:	e8 2d 2e 00 00       	call   80107d90 <freevm>
        release(&ptable.lock);
80104f63:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->state = UNUSED;
80104f6a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
80104f71:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104f78:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104f7f:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104f83:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
80104f8a:	e8 11 05 00 00       	call   801054a0 <release>
        return pid;
80104f8f:	83 c4 10             	add    $0x10,%esp
}
80104f92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f95:	89 f0                	mov    %esi,%eax
80104f97:	5b                   	pop    %ebx
80104f98:	5e                   	pop    %esi
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
      release(&ptable.lock);
80104f9b:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104f9e:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104fa3:	68 40 3d 11 80       	push   $0x80113d40
80104fa8:	e8 f3 04 00 00       	call   801054a0 <release>
      return -1;
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	eb e0                	jmp    80104f92 <waitx+0x102>
80104fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	53                   	push   %ebx
80104fc4:	83 ec 10             	sub    $0x10,%esp
80104fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104fca:	68 40 3d 11 80       	push   $0x80113d40
80104fcf:	e8 0c 04 00 00       	call   801053e0 <acquire>
80104fd4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fd7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104fdc:	eb 0e                	jmp    80104fec <wakeup+0x2c>
80104fde:	66 90                	xchg   %ax,%ax
80104fe0:	05 b0 00 00 00       	add    $0xb0,%eax
80104fe5:	3d 74 69 11 80       	cmp    $0x80116974,%eax
80104fea:	73 1e                	jae    8010500a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104fec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ff0:	75 ee                	jne    80104fe0 <wakeup+0x20>
80104ff2:	3b 58 20             	cmp    0x20(%eax),%ebx
80104ff5:	75 e9                	jne    80104fe0 <wakeup+0x20>
      p->state = RUNNABLE;
80104ff7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ffe:	05 b0 00 00 00       	add    $0xb0,%eax
80105003:	3d 74 69 11 80       	cmp    $0x80116974,%eax
80105008:	72 e2                	jb     80104fec <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010500a:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80105011:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105014:	c9                   	leave  
  release(&ptable.lock);
80105015:	e9 86 04 00 00       	jmp    801054a0 <release>
8010501a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105020 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 10             	sub    $0x10,%esp
80105027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010502a:	68 40 3d 11 80       	push   $0x80113d40
8010502f:	e8 ac 03 00 00       	call   801053e0 <acquire>
80105034:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105037:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010503c:	eb 0e                	jmp    8010504c <kill+0x2c>
8010503e:	66 90                	xchg   %ax,%ax
80105040:	05 b0 00 00 00       	add    $0xb0,%eax
80105045:	3d 74 69 11 80       	cmp    $0x80116974,%eax
8010504a:	73 34                	jae    80105080 <kill+0x60>
    if(p->pid == pid){
8010504c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010504f:	75 ef                	jne    80105040 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105051:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105055:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010505c:	75 07                	jne    80105065 <kill+0x45>
        p->state = RUNNABLE;
8010505e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105065:	83 ec 0c             	sub    $0xc,%esp
80105068:	68 40 3d 11 80       	push   $0x80113d40
8010506d:	e8 2e 04 00 00       	call   801054a0 <release>
      return 0;
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80105077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105080:	83 ec 0c             	sub    $0xc,%esp
80105083:	68 40 3d 11 80       	push   $0x80113d40
80105088:	e8 13 04 00 00       	call   801054a0 <release>
  return -1;
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105098:	c9                   	leave  
80105099:	c3                   	ret    
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
801050a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050a9:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
801050ae:	83 ec 3c             	sub    $0x3c,%esp
801050b1:	eb 27                	jmp    801050da <procdump+0x3a>
801050b3:	90                   	nop
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050b8:	83 ec 0c             	sub    $0xc,%esp
801050bb:	68 67 8b 10 80       	push   $0x80108b67
801050c0:	e8 9b b5 ff ff       	call   80100660 <cprintf>
801050c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050c8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801050ce:	81 fb 74 69 11 80    	cmp    $0x80116974,%ebx
801050d4:	0f 83 86 00 00 00    	jae    80105160 <procdump+0xc0>
    if(p->state == UNUSED)
801050da:	8b 43 0c             	mov    0xc(%ebx),%eax
801050dd:	85 c0                	test   %eax,%eax
801050df:	74 e7                	je     801050c8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050e1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801050e4:	ba 45 87 10 80       	mov    $0x80108745,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050e9:	77 11                	ja     801050fc <procdump+0x5c>
801050eb:	8b 14 85 50 88 10 80 	mov    -0x7fef77b0(,%eax,4),%edx
      state = "???";
801050f2:	b8 45 87 10 80       	mov    $0x80108745,%eax
801050f7:	85 d2                	test   %edx,%edx
801050f9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801050fc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801050ff:	50                   	push   %eax
80105100:	52                   	push   %edx
80105101:	ff 73 10             	pushl  0x10(%ebx)
80105104:	68 49 87 10 80       	push   $0x80108749
80105109:	e8 52 b5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80105115:	75 a1                	jne    801050b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105117:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010511a:	83 ec 08             	sub    $0x8,%esp
8010511d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105120:	50                   	push   %eax
80105121:	8b 43 1c             	mov    0x1c(%ebx),%eax
80105124:	8b 40 0c             	mov    0xc(%eax),%eax
80105127:	83 c0 08             	add    $0x8,%eax
8010512a:	50                   	push   %eax
8010512b:	e8 90 01 00 00       	call   801052c0 <getcallerpcs>
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	90                   	nop
80105134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80105138:	8b 17                	mov    (%edi),%edx
8010513a:	85 d2                	test   %edx,%edx
8010513c:	0f 84 76 ff ff ff    	je     801050b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105142:	83 ec 08             	sub    $0x8,%esp
80105145:	83 c7 04             	add    $0x4,%edi
80105148:	52                   	push   %edx
80105149:	68 01 81 10 80       	push   $0x80108101
8010514e:	e8 0d b5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	39 fe                	cmp    %edi,%esi
80105158:	75 de                	jne    80105138 <procdump+0x98>
8010515a:	e9 59 ff ff ff       	jmp    801050b8 <procdump+0x18>
8010515f:	90                   	nop
  }
}
80105160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105163:	5b                   	pop    %ebx
80105164:	5e                   	pop    %esi
80105165:	5f                   	pop    %edi
80105166:	5d                   	pop    %ebp
80105167:	c3                   	ret    
80105168:	66 90                	xchg   %ax,%ax
8010516a:	66 90                	xchg   %ax,%ax
8010516c:	66 90                	xchg   %ax,%ax
8010516e:	66 90                	xchg   %ax,%ax

80105170 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	53                   	push   %ebx
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010517a:	68 68 88 10 80       	push   $0x80108868
8010517f:	8d 43 04             	lea    0x4(%ebx),%eax
80105182:	50                   	push   %eax
80105183:	e8 18 01 00 00       	call   801052a0 <initlock>
  lk->name = name;
80105188:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010518b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105191:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105194:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010519b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010519e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a1:	c9                   	leave  
801051a2:	c3                   	ret    
801051a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
801051b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	8d 73 04             	lea    0x4(%ebx),%esi
801051be:	56                   	push   %esi
801051bf:	e8 1c 02 00 00       	call   801053e0 <acquire>
  while (lk->locked) {
801051c4:	8b 13                	mov    (%ebx),%edx
801051c6:	83 c4 10             	add    $0x10,%esp
801051c9:	85 d2                	test   %edx,%edx
801051cb:	74 16                	je     801051e3 <acquiresleep+0x33>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801051d0:	83 ec 08             	sub    $0x8,%esp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	e8 f6 fa ff ff       	call   80104cd0 <sleep>
  while (lk->locked) {
801051da:	8b 03                	mov    (%ebx),%eax
801051dc:	83 c4 10             	add    $0x10,%esp
801051df:	85 c0                	test   %eax,%eax
801051e1:	75 ed                	jne    801051d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801051e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801051e9:	e8 72 e6 ff ff       	call   80103860 <myproc>
801051ee:	8b 40 10             	mov    0x10(%eax),%eax
801051f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801051f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801051f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051fa:	5b                   	pop    %ebx
801051fb:	5e                   	pop    %esi
801051fc:	5d                   	pop    %ebp
  release(&lk->lk);
801051fd:	e9 9e 02 00 00       	jmp    801054a0 <release>
80105202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
80105215:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	8d 73 04             	lea    0x4(%ebx),%esi
8010521e:	56                   	push   %esi
8010521f:	e8 bc 01 00 00       	call   801053e0 <acquire>
  lk->locked = 0;
80105224:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010522a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105231:	89 1c 24             	mov    %ebx,(%esp)
80105234:	e8 87 fd ff ff       	call   80104fc0 <wakeup>
  release(&lk->lk);
80105239:	89 75 08             	mov    %esi,0x8(%ebp)
8010523c:	83 c4 10             	add    $0x10,%esp
}
8010523f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105242:	5b                   	pop    %ebx
80105243:	5e                   	pop    %esi
80105244:	5d                   	pop    %ebp
  release(&lk->lk);
80105245:	e9 56 02 00 00       	jmp    801054a0 <release>
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105250 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	53                   	push   %ebx
80105256:	31 ff                	xor    %edi,%edi
80105258:	83 ec 18             	sub    $0x18,%esp
8010525b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010525e:	8d 73 04             	lea    0x4(%ebx),%esi
80105261:	56                   	push   %esi
80105262:	e8 79 01 00 00       	call   801053e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105267:	8b 03                	mov    (%ebx),%eax
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	85 c0                	test   %eax,%eax
8010526e:	74 13                	je     80105283 <holdingsleep+0x33>
80105270:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105273:	e8 e8 e5 ff ff       	call   80103860 <myproc>
80105278:	39 58 10             	cmp    %ebx,0x10(%eax)
8010527b:	0f 94 c0             	sete   %al
8010527e:	0f b6 c0             	movzbl %al,%eax
80105281:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	56                   	push   %esi
80105287:	e8 14 02 00 00       	call   801054a0 <release>
  return r;
}
8010528c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010528f:	89 f8                	mov    %edi,%eax
80105291:	5b                   	pop    %ebx
80105292:	5e                   	pop    %esi
80105293:	5f                   	pop    %edi
80105294:	5d                   	pop    %ebp
80105295:	c3                   	ret    
80105296:	66 90                	xchg   %ax,%ax
80105298:	66 90                	xchg   %ax,%ax
8010529a:	66 90                	xchg   %ax,%ax
8010529c:	66 90                	xchg   %ax,%ax
8010529e:	66 90                	xchg   %ax,%ax

801052a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801052a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801052a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801052af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801052b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052b9:	5d                   	pop    %ebp
801052ba:	c3                   	ret    
801052bb:	90                   	nop
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801052c0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801052c1:	31 d2                	xor    %edx,%edx
{
801052c3:	89 e5                	mov    %esp,%ebp
801052c5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801052c6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801052c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801052cc:	83 e8 08             	sub    $0x8,%eax
801052cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052d0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801052d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801052dc:	77 1a                	ja     801052f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052de:	8b 58 04             	mov    0x4(%eax),%ebx
801052e1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801052e4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801052e7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801052e9:	83 fa 0a             	cmp    $0xa,%edx
801052ec:	75 e2                	jne    801052d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801052ee:	5b                   	pop    %ebx
801052ef:	5d                   	pop    %ebp
801052f0:	c3                   	ret    
801052f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052f8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801052fb:	83 c1 28             	add    $0x28,%ecx
801052fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105306:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105309:	39 c1                	cmp    %eax,%ecx
8010530b:	75 f3                	jne    80105300 <getcallerpcs+0x40>
}
8010530d:	5b                   	pop    %ebx
8010530e:	5d                   	pop    %ebp
8010530f:	c3                   	ret    

80105310 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	53                   	push   %ebx
80105314:	83 ec 04             	sub    $0x4,%esp
80105317:	9c                   	pushf  
80105318:	5b                   	pop    %ebx
  asm volatile("cli");
80105319:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010531a:	e8 b1 e4 ff ff       	call   801037d0 <mycpu>
8010531f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105325:	85 c0                	test   %eax,%eax
80105327:	75 11                	jne    8010533a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105329:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010532f:	e8 9c e4 ff ff       	call   801037d0 <mycpu>
80105334:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010533a:	e8 91 e4 ff ff       	call   801037d0 <mycpu>
8010533f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105346:	83 c4 04             	add    $0x4,%esp
80105349:	5b                   	pop    %ebx
8010534a:	5d                   	pop    %ebp
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105350 <popcli>:

void
popcli(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105356:	9c                   	pushf  
80105357:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105358:	f6 c4 02             	test   $0x2,%ah
8010535b:	75 35                	jne    80105392 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010535d:	e8 6e e4 ff ff       	call   801037d0 <mycpu>
80105362:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105369:	78 34                	js     8010539f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010536b:	e8 60 e4 ff ff       	call   801037d0 <mycpu>
80105370:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105376:	85 d2                	test   %edx,%edx
80105378:	74 06                	je     80105380 <popcli+0x30>
    sti();
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105380:	e8 4b e4 ff ff       	call   801037d0 <mycpu>
80105385:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010538b:	85 c0                	test   %eax,%eax
8010538d:	74 eb                	je     8010537a <popcli+0x2a>
  asm volatile("sti");
8010538f:	fb                   	sti    
}
80105390:	c9                   	leave  
80105391:	c3                   	ret    
    panic("popcli - interruptible");
80105392:	83 ec 0c             	sub    $0xc,%esp
80105395:	68 73 88 10 80       	push   $0x80108873
8010539a:	e8 f1 af ff ff       	call   80100390 <panic>
    panic("popcli");
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	68 8a 88 10 80       	push   $0x8010888a
801053a7:	e8 e4 af ff ff       	call   80100390 <panic>
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <holding>:
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
801053b5:	8b 75 08             	mov    0x8(%ebp),%esi
801053b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801053ba:	e8 51 ff ff ff       	call   80105310 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801053bf:	8b 06                	mov    (%esi),%eax
801053c1:	85 c0                	test   %eax,%eax
801053c3:	74 10                	je     801053d5 <holding+0x25>
801053c5:	8b 5e 08             	mov    0x8(%esi),%ebx
801053c8:	e8 03 e4 ff ff       	call   801037d0 <mycpu>
801053cd:	39 c3                	cmp    %eax,%ebx
801053cf:	0f 94 c3             	sete   %bl
801053d2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801053d5:	e8 76 ff ff ff       	call   80105350 <popcli>
}
801053da:	89 d8                	mov    %ebx,%eax
801053dc:	5b                   	pop    %ebx
801053dd:	5e                   	pop    %esi
801053de:	5d                   	pop    %ebp
801053df:	c3                   	ret    

801053e0 <acquire>:
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801053e5:	e8 26 ff ff ff       	call   80105310 <pushcli>
  if(holding(lk))
801053ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	53                   	push   %ebx
801053f1:	e8 ba ff ff ff       	call   801053b0 <holding>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	0f 85 83 00 00 00    	jne    80105484 <acquire+0xa4>
80105401:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105403:	ba 01 00 00 00       	mov    $0x1,%edx
80105408:	eb 09                	jmp    80105413 <acquire+0x33>
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105410:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105413:	89 d0                	mov    %edx,%eax
80105415:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105418:	85 c0                	test   %eax,%eax
8010541a:	75 f4                	jne    80105410 <acquire+0x30>
  __sync_synchronize();
8010541c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105421:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105424:	e8 a7 e3 ff ff       	call   801037d0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105429:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010542c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010542f:	89 e8                	mov    %ebp,%eax
80105431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105438:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010543e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105444:	77 1a                	ja     80105460 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105446:	8b 48 04             	mov    0x4(%eax),%ecx
80105449:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010544c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010544f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105451:	83 fe 0a             	cmp    $0xa,%esi
80105454:	75 e2                	jne    80105438 <acquire+0x58>
}
80105456:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105459:	5b                   	pop    %ebx
8010545a:	5e                   	pop    %esi
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
80105460:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105463:	83 c2 28             	add    $0x28,%edx
80105466:	8d 76 00             	lea    0x0(%esi),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105476:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105479:	39 d0                	cmp    %edx,%eax
8010547b:	75 f3                	jne    80105470 <acquire+0x90>
}
8010547d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105480:	5b                   	pop    %ebx
80105481:	5e                   	pop    %esi
80105482:	5d                   	pop    %ebp
80105483:	c3                   	ret    
    panic("acquire");
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	68 91 88 10 80       	push   $0x80108891
8010548c:	e8 ff ae ff ff       	call   80100390 <panic>
80105491:	eb 0d                	jmp    801054a0 <release>
80105493:	90                   	nop
80105494:	90                   	nop
80105495:	90                   	nop
80105496:	90                   	nop
80105497:	90                   	nop
80105498:	90                   	nop
80105499:	90                   	nop
8010549a:	90                   	nop
8010549b:	90                   	nop
8010549c:	90                   	nop
8010549d:	90                   	nop
8010549e:	90                   	nop
8010549f:	90                   	nop

801054a0 <release>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 10             	sub    $0x10,%esp
801054a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801054aa:	53                   	push   %ebx
801054ab:	e8 00 ff ff ff       	call   801053b0 <holding>
801054b0:	83 c4 10             	add    $0x10,%esp
801054b3:	85 c0                	test   %eax,%eax
801054b5:	74 22                	je     801054d9 <release+0x39>
  lk->pcs[0] = 0;
801054b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801054be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801054c5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801054ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801054d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054d3:	c9                   	leave  
  popcli();
801054d4:	e9 77 fe ff ff       	jmp    80105350 <popcli>
    panic("release");
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	68 99 88 10 80       	push   $0x80108899
801054e1:	e8 aa ae ff ff       	call   80100390 <panic>
801054e6:	66 90                	xchg   %ax,%ax
801054e8:	66 90                	xchg   %ax,%ax
801054ea:	66 90                	xchg   %ax,%ax
801054ec:	66 90                	xchg   %ax,%ax
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	53                   	push   %ebx
801054f5:	8b 55 08             	mov    0x8(%ebp),%edx
801054f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801054fb:	f6 c2 03             	test   $0x3,%dl
801054fe:	75 05                	jne    80105505 <memset+0x15>
80105500:	f6 c1 03             	test   $0x3,%cl
80105503:	74 13                	je     80105518 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105505:	89 d7                	mov    %edx,%edi
80105507:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550a:	fc                   	cld    
8010550b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010550d:	5b                   	pop    %ebx
8010550e:	89 d0                	mov    %edx,%eax
80105510:	5f                   	pop    %edi
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105518:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010551c:	c1 e9 02             	shr    $0x2,%ecx
8010551f:	89 f8                	mov    %edi,%eax
80105521:	89 fb                	mov    %edi,%ebx
80105523:	c1 e0 18             	shl    $0x18,%eax
80105526:	c1 e3 10             	shl    $0x10,%ebx
80105529:	09 d8                	or     %ebx,%eax
8010552b:	09 f8                	or     %edi,%eax
8010552d:	c1 e7 08             	shl    $0x8,%edi
80105530:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105532:	89 d7                	mov    %edx,%edi
80105534:	fc                   	cld    
80105535:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105537:	5b                   	pop    %ebx
80105538:	89 d0                	mov    %edx,%eax
8010553a:	5f                   	pop    %edi
8010553b:	5d                   	pop    %ebp
8010553c:	c3                   	ret    
8010553d:	8d 76 00             	lea    0x0(%esi),%esi

80105540 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
80105546:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105549:	8b 75 08             	mov    0x8(%ebp),%esi
8010554c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010554f:	85 db                	test   %ebx,%ebx
80105551:	74 29                	je     8010557c <memcmp+0x3c>
    if(*s1 != *s2)
80105553:	0f b6 16             	movzbl (%esi),%edx
80105556:	0f b6 0f             	movzbl (%edi),%ecx
80105559:	38 d1                	cmp    %dl,%cl
8010555b:	75 2b                	jne    80105588 <memcmp+0x48>
8010555d:	b8 01 00 00 00       	mov    $0x1,%eax
80105562:	eb 14                	jmp    80105578 <memcmp+0x38>
80105564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105568:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010556c:	83 c0 01             	add    $0x1,%eax
8010556f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105574:	38 ca                	cmp    %cl,%dl
80105576:	75 10                	jne    80105588 <memcmp+0x48>
  while(n-- > 0){
80105578:	39 d8                	cmp    %ebx,%eax
8010557a:	75 ec                	jne    80105568 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010557c:	5b                   	pop    %ebx
  return 0;
8010557d:	31 c0                	xor    %eax,%eax
}
8010557f:	5e                   	pop    %esi
80105580:	5f                   	pop    %edi
80105581:	5d                   	pop    %ebp
80105582:	c3                   	ret    
80105583:	90                   	nop
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105588:	0f b6 c2             	movzbl %dl,%eax
}
8010558b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010558c:	29 c8                	sub    %ecx,%eax
}
8010558e:	5e                   	pop    %esi
8010558f:	5f                   	pop    %edi
80105590:	5d                   	pop    %ebp
80105591:	c3                   	ret    
80105592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	56                   	push   %esi
801055a4:	53                   	push   %ebx
801055a5:	8b 45 08             	mov    0x8(%ebp),%eax
801055a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801055ab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801055ae:	39 c3                	cmp    %eax,%ebx
801055b0:	73 26                	jae    801055d8 <memmove+0x38>
801055b2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801055b5:	39 c8                	cmp    %ecx,%eax
801055b7:	73 1f                	jae    801055d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801055b9:	85 f6                	test   %esi,%esi
801055bb:	8d 56 ff             	lea    -0x1(%esi),%edx
801055be:	74 0f                	je     801055cf <memmove+0x2f>
      *--d = *--s;
801055c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801055c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801055c7:	83 ea 01             	sub    $0x1,%edx
801055ca:	83 fa ff             	cmp    $0xffffffff,%edx
801055cd:	75 f1                	jne    801055c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801055cf:	5b                   	pop    %ebx
801055d0:	5e                   	pop    %esi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	90                   	nop
801055d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801055d8:	31 d2                	xor    %edx,%edx
801055da:	85 f6                	test   %esi,%esi
801055dc:	74 f1                	je     801055cf <memmove+0x2f>
801055de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801055e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801055e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801055e7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801055ea:	39 d6                	cmp    %edx,%esi
801055ec:	75 f2                	jne    801055e0 <memmove+0x40>
}
801055ee:	5b                   	pop    %ebx
801055ef:	5e                   	pop    %esi
801055f0:	5d                   	pop    %ebp
801055f1:	c3                   	ret    
801055f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105603:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105604:	eb 9a                	jmp    801055a0 <memmove>
80105606:	8d 76 00             	lea    0x0(%esi),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	8b 7d 10             	mov    0x10(%ebp),%edi
80105618:	53                   	push   %ebx
80105619:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010561c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010561f:	85 ff                	test   %edi,%edi
80105621:	74 2f                	je     80105652 <strncmp+0x42>
80105623:	0f b6 01             	movzbl (%ecx),%eax
80105626:	0f b6 1e             	movzbl (%esi),%ebx
80105629:	84 c0                	test   %al,%al
8010562b:	74 37                	je     80105664 <strncmp+0x54>
8010562d:	38 c3                	cmp    %al,%bl
8010562f:	75 33                	jne    80105664 <strncmp+0x54>
80105631:	01 f7                	add    %esi,%edi
80105633:	eb 13                	jmp    80105648 <strncmp+0x38>
80105635:	8d 76 00             	lea    0x0(%esi),%esi
80105638:	0f b6 01             	movzbl (%ecx),%eax
8010563b:	84 c0                	test   %al,%al
8010563d:	74 21                	je     80105660 <strncmp+0x50>
8010563f:	0f b6 1a             	movzbl (%edx),%ebx
80105642:	89 d6                	mov    %edx,%esi
80105644:	38 d8                	cmp    %bl,%al
80105646:	75 1c                	jne    80105664 <strncmp+0x54>
    n--, p++, q++;
80105648:	8d 56 01             	lea    0x1(%esi),%edx
8010564b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010564e:	39 fa                	cmp    %edi,%edx
80105650:	75 e6                	jne    80105638 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105652:	5b                   	pop    %ebx
    return 0;
80105653:	31 c0                	xor    %eax,%eax
}
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105660:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105664:	29 d8                	sub    %ebx,%eax
}
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	90                   	nop
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
80105675:	8b 45 08             	mov    0x8(%ebp),%eax
80105678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010567b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010567e:	89 c2                	mov    %eax,%edx
80105680:	eb 19                	jmp    8010569b <strncpy+0x2b>
80105682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105688:	83 c3 01             	add    $0x1,%ebx
8010568b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010568f:	83 c2 01             	add    $0x1,%edx
80105692:	84 c9                	test   %cl,%cl
80105694:	88 4a ff             	mov    %cl,-0x1(%edx)
80105697:	74 09                	je     801056a2 <strncpy+0x32>
80105699:	89 f1                	mov    %esi,%ecx
8010569b:	85 c9                	test   %ecx,%ecx
8010569d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801056a0:	7f e6                	jg     80105688 <strncpy+0x18>
    ;
  while(n-- > 0)
801056a2:	31 c9                	xor    %ecx,%ecx
801056a4:	85 f6                	test   %esi,%esi
801056a6:	7e 17                	jle    801056bf <strncpy+0x4f>
801056a8:	90                   	nop
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801056b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801056b4:	89 f3                	mov    %esi,%ebx
801056b6:	83 c1 01             	add    $0x1,%ecx
801056b9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801056bb:	85 db                	test   %ebx,%ebx
801056bd:	7f f1                	jg     801056b0 <strncpy+0x40>
  return os;
}
801056bf:	5b                   	pop    %ebx
801056c0:	5e                   	pop    %esi
801056c1:	5d                   	pop    %ebp
801056c2:	c3                   	ret    
801056c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801056d8:	8b 45 08             	mov    0x8(%ebp),%eax
801056db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801056de:	85 c9                	test   %ecx,%ecx
801056e0:	7e 26                	jle    80105708 <safestrcpy+0x38>
801056e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801056e6:	89 c1                	mov    %eax,%ecx
801056e8:	eb 17                	jmp    80105701 <safestrcpy+0x31>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801056f0:	83 c2 01             	add    $0x1,%edx
801056f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801056f7:	83 c1 01             	add    $0x1,%ecx
801056fa:	84 db                	test   %bl,%bl
801056fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801056ff:	74 04                	je     80105705 <safestrcpy+0x35>
80105701:	39 f2                	cmp    %esi,%edx
80105703:	75 eb                	jne    801056f0 <safestrcpy+0x20>
    ;
  *s = 0;
80105705:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105708:	5b                   	pop    %ebx
80105709:	5e                   	pop    %esi
8010570a:	5d                   	pop    %ebp
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <strlen>:

int
strlen(const char *s)
{
80105710:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105711:	31 c0                	xor    %eax,%eax
{
80105713:	89 e5                	mov    %esp,%ebp
80105715:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105718:	80 3a 00             	cmpb   $0x0,(%edx)
8010571b:	74 0c                	je     80105729 <strlen+0x19>
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
80105720:	83 c0 01             	add    $0x1,%eax
80105723:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105727:	75 f7                	jne    80105720 <strlen+0x10>
    ;
  return n;
}
80105729:	5d                   	pop    %ebp
8010572a:	c3                   	ret    

8010572b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010572b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010572f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105733:	55                   	push   %ebp
  pushl %ebx
80105734:	53                   	push   %ebx
  pushl %esi
80105735:	56                   	push   %esi
  pushl %edi
80105736:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105737:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105739:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010573b:	5f                   	pop    %edi
  popl %esi
8010573c:	5e                   	pop    %esi
  popl %ebx
8010573d:	5b                   	pop    %ebx
  popl %ebp
8010573e:	5d                   	pop    %ebp
  ret
8010573f:	c3                   	ret    

80105740 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	53                   	push   %ebx
80105744:	83 ec 04             	sub    $0x4,%esp
80105747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010574a:	e8 11 e1 ff ff       	call   80103860 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010574f:	8b 00                	mov    (%eax),%eax
80105751:	39 d8                	cmp    %ebx,%eax
80105753:	76 1b                	jbe    80105770 <fetchint+0x30>
80105755:	8d 53 04             	lea    0x4(%ebx),%edx
80105758:	39 d0                	cmp    %edx,%eax
8010575a:	72 14                	jb     80105770 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010575c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010575f:	8b 13                	mov    (%ebx),%edx
80105761:	89 10                	mov    %edx,(%eax)
  return 0;
80105763:	31 c0                	xor    %eax,%eax
}
80105765:	83 c4 04             	add    $0x4,%esp
80105768:	5b                   	pop    %ebx
80105769:	5d                   	pop    %ebp
8010576a:	c3                   	ret    
8010576b:	90                   	nop
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105775:	eb ee                	jmp    80105765 <fetchint+0x25>
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 04             	sub    $0x4,%esp
80105787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010578a:	e8 d1 e0 ff ff       	call   80103860 <myproc>

  if(addr >= curproc->sz)
8010578f:	39 18                	cmp    %ebx,(%eax)
80105791:	76 29                	jbe    801057bc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105793:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105796:	89 da                	mov    %ebx,%edx
80105798:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010579a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010579c:	39 c3                	cmp    %eax,%ebx
8010579e:	73 1c                	jae    801057bc <fetchstr+0x3c>
    if(*s == 0)
801057a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801057a3:	75 10                	jne    801057b5 <fetchstr+0x35>
801057a5:	eb 39                	jmp    801057e0 <fetchstr+0x60>
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801057b0:	80 3a 00             	cmpb   $0x0,(%edx)
801057b3:	74 1b                	je     801057d0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801057b5:	83 c2 01             	add    $0x1,%edx
801057b8:	39 d0                	cmp    %edx,%eax
801057ba:	77 f4                	ja     801057b0 <fetchstr+0x30>
    return -1;
801057bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801057c1:	83 c4 04             	add    $0x4,%esp
801057c4:	5b                   	pop    %ebx
801057c5:	5d                   	pop    %ebp
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801057d0:	83 c4 04             	add    $0x4,%esp
801057d3:	89 d0                	mov    %edx,%eax
801057d5:	29 d8                	sub    %ebx,%eax
801057d7:	5b                   	pop    %ebx
801057d8:	5d                   	pop    %ebp
801057d9:	c3                   	ret    
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801057e0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801057e2:	eb dd                	jmp    801057c1 <fetchstr+0x41>
801057e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	56                   	push   %esi
801057f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057f5:	e8 66 e0 ff ff       	call   80103860 <myproc>
801057fa:	8b 40 18             	mov    0x18(%eax),%eax
801057fd:	8b 55 08             	mov    0x8(%ebp),%edx
80105800:	8b 40 44             	mov    0x44(%eax),%eax
80105803:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105806:	e8 55 e0 ff ff       	call   80103860 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010580b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010580d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105810:	39 c6                	cmp    %eax,%esi
80105812:	73 1c                	jae    80105830 <argint+0x40>
80105814:	8d 53 08             	lea    0x8(%ebx),%edx
80105817:	39 d0                	cmp    %edx,%eax
80105819:	72 15                	jb     80105830 <argint+0x40>
  *ip = *(int*)(addr);
8010581b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010581e:	8b 53 04             	mov    0x4(%ebx),%edx
80105821:	89 10                	mov    %edx,(%eax)
  return 0;
80105823:	31 c0                	xor    %eax,%eax
}
80105825:	5b                   	pop    %ebx
80105826:	5e                   	pop    %esi
80105827:	5d                   	pop    %ebp
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105835:	eb ee                	jmp    80105825 <argint+0x35>
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	56                   	push   %esi
80105844:	53                   	push   %ebx
80105845:	83 ec 10             	sub    $0x10,%esp
80105848:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010584b:	e8 10 e0 ff ff       	call   80103860 <myproc>
80105850:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105852:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105855:	83 ec 08             	sub    $0x8,%esp
80105858:	50                   	push   %eax
80105859:	ff 75 08             	pushl  0x8(%ebp)
8010585c:	e8 8f ff ff ff       	call   801057f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	85 c0                	test   %eax,%eax
80105866:	78 28                	js     80105890 <argptr+0x50>
80105868:	85 db                	test   %ebx,%ebx
8010586a:	78 24                	js     80105890 <argptr+0x50>
8010586c:	8b 16                	mov    (%esi),%edx
8010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105871:	39 c2                	cmp    %eax,%edx
80105873:	76 1b                	jbe    80105890 <argptr+0x50>
80105875:	01 c3                	add    %eax,%ebx
80105877:	39 da                	cmp    %ebx,%edx
80105879:	72 15                	jb     80105890 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010587b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010587e:	89 02                	mov    %eax,(%edx)
  return 0;
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105885:	5b                   	pop    %ebx
80105886:	5e                   	pop    %esi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	eb eb                	jmp    80105882 <argptr+0x42>
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	50                   	push   %eax
801058aa:	ff 75 08             	pushl  0x8(%ebp)
801058ad:	e8 3e ff ff ff       	call   801057f0 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 17                	js     801058d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801058b9:	83 ec 08             	sub    $0x8,%esp
801058bc:	ff 75 0c             	pushl  0xc(%ebp)
801058bf:	ff 75 f4             	pushl  -0xc(%ebp)
801058c2:	e8 b9 fe ff ff       	call   80105780 <fetchstr>
801058c7:	83 c4 10             	add    $0x10,%esp
}
801058ca:	c9                   	leave  
801058cb:	c3                   	ret    
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <syscall>:
[SYS_set_priority]   sys_set_priority,
};

void
syscall(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
801058e4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801058e7:	e8 74 df ff ff       	call   80103860 <myproc>
801058ec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801058ee:	8b 40 18             	mov    0x18(%eax),%eax
801058f1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801058f7:	83 fa 18             	cmp    $0x18,%edx
801058fa:	77 1c                	ja     80105918 <syscall+0x38>
801058fc:	8b 14 85 c0 88 10 80 	mov    -0x7fef7740(,%eax,4),%edx
80105903:	85 d2                	test   %edx,%edx
80105905:	74 11                	je     80105918 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105907:	ff d2                	call   *%edx
80105909:	8b 53 18             	mov    0x18(%ebx),%edx
8010590c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010590f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105912:	c9                   	leave  
80105913:	c3                   	ret    
80105914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105918:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105919:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010591c:	50                   	push   %eax
8010591d:	ff 73 10             	pushl  0x10(%ebx)
80105920:	68 a1 88 10 80       	push   $0x801088a1
80105925:	e8 36 ad ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010592a:	8b 43 18             	mov    0x18(%ebx),%eax
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105946:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105949:	83 ec 34             	sub    $0x34,%esp
8010594c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010594f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105952:	56                   	push   %esi
80105953:	50                   	push   %eax
{
80105954:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105957:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010595a:	e8 a1 c5 ff ff       	call   80101f00 <nameiparent>
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	85 c0                	test   %eax,%eax
80105964:	0f 84 46 01 00 00    	je     80105ab0 <create+0x170>
    return 0;
  ilock(dp);
8010596a:	83 ec 0c             	sub    $0xc,%esp
8010596d:	89 c3                	mov    %eax,%ebx
8010596f:	50                   	push   %eax
80105970:	e8 0b bd ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105975:	83 c4 0c             	add    $0xc,%esp
80105978:	6a 00                	push   $0x0
8010597a:	56                   	push   %esi
8010597b:	53                   	push   %ebx
8010597c:	e8 2f c2 ff ff       	call   80101bb0 <dirlookup>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	89 c7                	mov    %eax,%edi
80105988:	74 36                	je     801059c0 <create+0x80>
    iunlockput(dp);
8010598a:	83 ec 0c             	sub    $0xc,%esp
8010598d:	53                   	push   %ebx
8010598e:	e8 7d bf ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105993:	89 3c 24             	mov    %edi,(%esp)
80105996:	e8 e5 bc ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010599b:	83 c4 10             	add    $0x10,%esp
8010599e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801059a3:	0f 85 97 00 00 00    	jne    80105a40 <create+0x100>
801059a9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801059ae:	0f 85 8c 00 00 00    	jne    80105a40 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801059b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b7:	89 f8                	mov    %edi,%eax
801059b9:	5b                   	pop    %ebx
801059ba:	5e                   	pop    %esi
801059bb:	5f                   	pop    %edi
801059bc:	5d                   	pop    %ebp
801059bd:	c3                   	ret    
801059be:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801059c0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801059c4:	83 ec 08             	sub    $0x8,%esp
801059c7:	50                   	push   %eax
801059c8:	ff 33                	pushl  (%ebx)
801059ca:	e8 41 bb ff ff       	call   80101510 <ialloc>
801059cf:	83 c4 10             	add    $0x10,%esp
801059d2:	85 c0                	test   %eax,%eax
801059d4:	89 c7                	mov    %eax,%edi
801059d6:	0f 84 e8 00 00 00    	je     80105ac4 <create+0x184>
  ilock(ip);
801059dc:	83 ec 0c             	sub    $0xc,%esp
801059df:	50                   	push   %eax
801059e0:	e8 9b bc ff ff       	call   80101680 <ilock>
  ip->major = major;
801059e5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801059e9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801059ed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801059f1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801059f5:	b8 01 00 00 00       	mov    $0x1,%eax
801059fa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801059fe:	89 3c 24             	mov    %edi,(%esp)
80105a01:	e8 ca bb ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105a0e:	74 50                	je     80105a60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105a10:	83 ec 04             	sub    $0x4,%esp
80105a13:	ff 77 04             	pushl  0x4(%edi)
80105a16:	56                   	push   %esi
80105a17:	53                   	push   %ebx
80105a18:	e8 03 c4 ff ff       	call   80101e20 <dirlink>
80105a1d:	83 c4 10             	add    $0x10,%esp
80105a20:	85 c0                	test   %eax,%eax
80105a22:	0f 88 8f 00 00 00    	js     80105ab7 <create+0x177>
  iunlockput(dp);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	53                   	push   %ebx
80105a2c:	e8 df be ff ff       	call   80101910 <iunlockput>
  return ip;
80105a31:	83 c4 10             	add    $0x10,%esp
}
80105a34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a37:	89 f8                	mov    %edi,%eax
80105a39:	5b                   	pop    %ebx
80105a3a:	5e                   	pop    %esi
80105a3b:	5f                   	pop    %edi
80105a3c:	5d                   	pop    %ebp
80105a3d:	c3                   	ret    
80105a3e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	57                   	push   %edi
    return 0;
80105a44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105a46:	e8 c5 be ff ff       	call   80101910 <iunlockput>
    return 0;
80105a4b:	83 c4 10             	add    $0x10,%esp
}
80105a4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a51:	89 f8                	mov    %edi,%eax
80105a53:	5b                   	pop    %ebx
80105a54:	5e                   	pop    %esi
80105a55:	5f                   	pop    %edi
80105a56:	5d                   	pop    %ebp
80105a57:	c3                   	ret    
80105a58:	90                   	nop
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105a60:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105a65:	83 ec 0c             	sub    $0xc,%esp
80105a68:	53                   	push   %ebx
80105a69:	e8 62 bb ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a6e:	83 c4 0c             	add    $0xc,%esp
80105a71:	ff 77 04             	pushl  0x4(%edi)
80105a74:	68 44 89 10 80       	push   $0x80108944
80105a79:	57                   	push   %edi
80105a7a:	e8 a1 c3 ff ff       	call   80101e20 <dirlink>
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	85 c0                	test   %eax,%eax
80105a84:	78 1c                	js     80105aa2 <create+0x162>
80105a86:	83 ec 04             	sub    $0x4,%esp
80105a89:	ff 73 04             	pushl  0x4(%ebx)
80105a8c:	68 43 89 10 80       	push   $0x80108943
80105a91:	57                   	push   %edi
80105a92:	e8 89 c3 ff ff       	call   80101e20 <dirlink>
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	0f 89 6e ff ff ff    	jns    80105a10 <create+0xd0>
      panic("create dots");
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	68 37 89 10 80       	push   $0x80108937
80105aaa:	e8 e1 a8 ff ff       	call   80100390 <panic>
80105aaf:	90                   	nop
    return 0;
80105ab0:	31 ff                	xor    %edi,%edi
80105ab2:	e9 fd fe ff ff       	jmp    801059b4 <create+0x74>
    panic("create: dirlink");
80105ab7:	83 ec 0c             	sub    $0xc,%esp
80105aba:	68 46 89 10 80       	push   $0x80108946
80105abf:	e8 cc a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105ac4:	83 ec 0c             	sub    $0xc,%esp
80105ac7:	68 28 89 10 80       	push   $0x80108928
80105acc:	e8 bf a8 ff ff       	call   80100390 <panic>
80105ad1:	eb 0d                	jmp    80105ae0 <argfd.constprop.0>
80105ad3:	90                   	nop
80105ad4:	90                   	nop
80105ad5:	90                   	nop
80105ad6:	90                   	nop
80105ad7:	90                   	nop
80105ad8:	90                   	nop
80105ad9:	90                   	nop
80105ada:	90                   	nop
80105adb:	90                   	nop
80105adc:	90                   	nop
80105add:	90                   	nop
80105ade:	90                   	nop
80105adf:	90                   	nop

80105ae0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
80105ae5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105ae7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105aea:	89 d6                	mov    %edx,%esi
80105aec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105aef:	50                   	push   %eax
80105af0:	6a 00                	push   $0x0
80105af2:	e8 f9 fc ff ff       	call   801057f0 <argint>
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	85 c0                	test   %eax,%eax
80105afc:	78 2a                	js     80105b28 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105afe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b02:	77 24                	ja     80105b28 <argfd.constprop.0+0x48>
80105b04:	e8 57 dd ff ff       	call   80103860 <myproc>
80105b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b0c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105b10:	85 c0                	test   %eax,%eax
80105b12:	74 14                	je     80105b28 <argfd.constprop.0+0x48>
  if(pfd)
80105b14:	85 db                	test   %ebx,%ebx
80105b16:	74 02                	je     80105b1a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105b18:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105b1a:	89 06                	mov    %eax,(%esi)
  return 0;
80105b1c:	31 c0                	xor    %eax,%eax
}
80105b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b21:	5b                   	pop    %ebx
80105b22:	5e                   	pop    %esi
80105b23:	5d                   	pop    %ebp
80105b24:	c3                   	ret    
80105b25:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2d:	eb ef                	jmp    80105b1e <argfd.constprop.0+0x3e>
80105b2f:	90                   	nop

80105b30 <sys_dup>:
{
80105b30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105b31:	31 c0                	xor    %eax,%eax
{
80105b33:	89 e5                	mov    %esp,%ebp
80105b35:	56                   	push   %esi
80105b36:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105b37:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105b3a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105b3d:	e8 9e ff ff ff       	call   80105ae0 <argfd.constprop.0>
80105b42:	85 c0                	test   %eax,%eax
80105b44:	78 42                	js     80105b88 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105b46:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b49:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b4b:	e8 10 dd ff ff       	call   80103860 <myproc>
80105b50:	eb 0e                	jmp    80105b60 <sys_dup+0x30>
80105b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b58:	83 c3 01             	add    $0x1,%ebx
80105b5b:	83 fb 10             	cmp    $0x10,%ebx
80105b5e:	74 28                	je     80105b88 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105b60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b64:	85 d2                	test   %edx,%edx
80105b66:	75 f0                	jne    80105b58 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105b68:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105b6c:	83 ec 0c             	sub    $0xc,%esp
80105b6f:	ff 75 f4             	pushl  -0xc(%ebp)
80105b72:	e8 79 b2 ff ff       	call   80100df0 <filedup>
  return fd;
80105b77:	83 c4 10             	add    $0x10,%esp
}
80105b7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b7d:	89 d8                	mov    %ebx,%eax
80105b7f:	5b                   	pop    %ebx
80105b80:	5e                   	pop    %esi
80105b81:	5d                   	pop    %ebp
80105b82:	c3                   	ret    
80105b83:	90                   	nop
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105b8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105b90:	89 d8                	mov    %ebx,%eax
80105b92:	5b                   	pop    %ebx
80105b93:	5e                   	pop    %esi
80105b94:	5d                   	pop    %ebp
80105b95:	c3                   	ret    
80105b96:	8d 76 00             	lea    0x0(%esi),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ba0 <sys_read>:
{
80105ba0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ba1:	31 c0                	xor    %eax,%eax
{
80105ba3:	89 e5                	mov    %esp,%ebp
80105ba5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ba8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105bab:	e8 30 ff ff ff       	call   80105ae0 <argfd.constprop.0>
80105bb0:	85 c0                	test   %eax,%eax
80105bb2:	78 4c                	js     80105c00 <sys_read+0x60>
80105bb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	50                   	push   %eax
80105bbb:	6a 02                	push   $0x2
80105bbd:	e8 2e fc ff ff       	call   801057f0 <argint>
80105bc2:	83 c4 10             	add    $0x10,%esp
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	78 37                	js     80105c00 <sys_read+0x60>
80105bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bcc:	83 ec 04             	sub    $0x4,%esp
80105bcf:	ff 75 f0             	pushl  -0x10(%ebp)
80105bd2:	50                   	push   %eax
80105bd3:	6a 01                	push   $0x1
80105bd5:	e8 66 fc ff ff       	call   80105840 <argptr>
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	78 1f                	js     80105c00 <sys_read+0x60>
  return fileread(f, p, n);
80105be1:	83 ec 04             	sub    $0x4,%esp
80105be4:	ff 75 f0             	pushl  -0x10(%ebp)
80105be7:	ff 75 f4             	pushl  -0xc(%ebp)
80105bea:	ff 75 ec             	pushl  -0x14(%ebp)
80105bed:	e8 6e b3 ff ff       	call   80100f60 <fileread>
80105bf2:	83 c4 10             	add    $0x10,%esp
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c10 <sys_write>:
{
80105c10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c11:	31 c0                	xor    %eax,%eax
{
80105c13:	89 e5                	mov    %esp,%ebp
80105c15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105c1b:	e8 c0 fe ff ff       	call   80105ae0 <argfd.constprop.0>
80105c20:	85 c0                	test   %eax,%eax
80105c22:	78 4c                	js     80105c70 <sys_write+0x60>
80105c24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c27:	83 ec 08             	sub    $0x8,%esp
80105c2a:	50                   	push   %eax
80105c2b:	6a 02                	push   $0x2
80105c2d:	e8 be fb ff ff       	call   801057f0 <argint>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	78 37                	js     80105c70 <sys_write+0x60>
80105c39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c3c:	83 ec 04             	sub    $0x4,%esp
80105c3f:	ff 75 f0             	pushl  -0x10(%ebp)
80105c42:	50                   	push   %eax
80105c43:	6a 01                	push   $0x1
80105c45:	e8 f6 fb ff ff       	call   80105840 <argptr>
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	85 c0                	test   %eax,%eax
80105c4f:	78 1f                	js     80105c70 <sys_write+0x60>
  return filewrite(f, p, n);
80105c51:	83 ec 04             	sub    $0x4,%esp
80105c54:	ff 75 f0             	pushl  -0x10(%ebp)
80105c57:	ff 75 f4             	pushl  -0xc(%ebp)
80105c5a:	ff 75 ec             	pushl  -0x14(%ebp)
80105c5d:	e8 8e b3 ff ff       	call   80100ff0 <filewrite>
80105c62:	83 c4 10             	add    $0x10,%esp
}
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <sys_close>:
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105c86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105c89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c8c:	e8 4f fe ff ff       	call   80105ae0 <argfd.constprop.0>
80105c91:	85 c0                	test   %eax,%eax
80105c93:	78 2b                	js     80105cc0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105c95:	e8 c6 db ff ff       	call   80103860 <myproc>
80105c9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105c9d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105ca0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105ca7:	00 
  fileclose(f);
80105ca8:	ff 75 f4             	pushl  -0xc(%ebp)
80105cab:	e8 90 b1 ff ff       	call   80100e40 <fileclose>
  return 0;
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	31 c0                	xor    %eax,%eax
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    
80105cb7:	89 f6                	mov    %esi,%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_fstat>:
{
80105cd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105cd1:	31 c0                	xor    %eax,%eax
{
80105cd3:	89 e5                	mov    %esp,%ebp
80105cd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105cd8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105cdb:	e8 00 fe ff ff       	call   80105ae0 <argfd.constprop.0>
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	78 2c                	js     80105d10 <sys_fstat+0x40>
80105ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce7:	83 ec 04             	sub    $0x4,%esp
80105cea:	6a 14                	push   $0x14
80105cec:	50                   	push   %eax
80105ced:	6a 01                	push   $0x1
80105cef:	e8 4c fb ff ff       	call   80105840 <argptr>
80105cf4:	83 c4 10             	add    $0x10,%esp
80105cf7:	85 c0                	test   %eax,%eax
80105cf9:	78 15                	js     80105d10 <sys_fstat+0x40>
  return filestat(f, st);
80105cfb:	83 ec 08             	sub    $0x8,%esp
80105cfe:	ff 75 f4             	pushl  -0xc(%ebp)
80105d01:	ff 75 f0             	pushl  -0x10(%ebp)
80105d04:	e8 07 b2 ff ff       	call   80100f10 <filestat>
80105d09:	83 c4 10             	add    $0x10,%esp
}
80105d0c:	c9                   	leave  
80105d0d:	c3                   	ret    
80105d0e:	66 90                	xchg   %ax,%ax
    return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d20 <sys_link>:
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
80105d25:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d26:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105d29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d2c:	50                   	push   %eax
80105d2d:	6a 00                	push   $0x0
80105d2f:	e8 6c fb ff ff       	call   801058a0 <argstr>
80105d34:	83 c4 10             	add    $0x10,%esp
80105d37:	85 c0                	test   %eax,%eax
80105d39:	0f 88 fb 00 00 00    	js     80105e3a <sys_link+0x11a>
80105d3f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105d42:	83 ec 08             	sub    $0x8,%esp
80105d45:	50                   	push   %eax
80105d46:	6a 01                	push   $0x1
80105d48:	e8 53 fb ff ff       	call   801058a0 <argstr>
80105d4d:	83 c4 10             	add    $0x10,%esp
80105d50:	85 c0                	test   %eax,%eax
80105d52:	0f 88 e2 00 00 00    	js     80105e3a <sys_link+0x11a>
  begin_op();
80105d58:	e8 43 ce ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	ff 75 d4             	pushl  -0x2c(%ebp)
80105d63:	e8 78 c1 ff ff       	call   80101ee0 <namei>
80105d68:	83 c4 10             	add    $0x10,%esp
80105d6b:	85 c0                	test   %eax,%eax
80105d6d:	89 c3                	mov    %eax,%ebx
80105d6f:	0f 84 ea 00 00 00    	je     80105e5f <sys_link+0x13f>
  ilock(ip);
80105d75:	83 ec 0c             	sub    $0xc,%esp
80105d78:	50                   	push   %eax
80105d79:	e8 02 b9 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d86:	0f 84 bb 00 00 00    	je     80105e47 <sys_link+0x127>
  ip->nlink++;
80105d8c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105d91:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105d94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105d97:	53                   	push   %ebx
80105d98:	e8 33 b8 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105d9d:	89 1c 24             	mov    %ebx,(%esp)
80105da0:	e8 bb b9 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105da5:	58                   	pop    %eax
80105da6:	5a                   	pop    %edx
80105da7:	57                   	push   %edi
80105da8:	ff 75 d0             	pushl  -0x30(%ebp)
80105dab:	e8 50 c1 ff ff       	call   80101f00 <nameiparent>
80105db0:	83 c4 10             	add    $0x10,%esp
80105db3:	85 c0                	test   %eax,%eax
80105db5:	89 c6                	mov    %eax,%esi
80105db7:	74 5b                	je     80105e14 <sys_link+0xf4>
  ilock(dp);
80105db9:	83 ec 0c             	sub    $0xc,%esp
80105dbc:	50                   	push   %eax
80105dbd:	e8 be b8 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	8b 03                	mov    (%ebx),%eax
80105dc7:	39 06                	cmp    %eax,(%esi)
80105dc9:	75 3d                	jne    80105e08 <sys_link+0xe8>
80105dcb:	83 ec 04             	sub    $0x4,%esp
80105dce:	ff 73 04             	pushl  0x4(%ebx)
80105dd1:	57                   	push   %edi
80105dd2:	56                   	push   %esi
80105dd3:	e8 48 c0 ff ff       	call   80101e20 <dirlink>
80105dd8:	83 c4 10             	add    $0x10,%esp
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	78 29                	js     80105e08 <sys_link+0xe8>
  iunlockput(dp);
80105ddf:	83 ec 0c             	sub    $0xc,%esp
80105de2:	56                   	push   %esi
80105de3:	e8 28 bb ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105de8:	89 1c 24             	mov    %ebx,(%esp)
80105deb:	e8 c0 b9 ff ff       	call   801017b0 <iput>
  end_op();
80105df0:	e8 1b ce ff ff       	call   80102c10 <end_op>
  return 0;
80105df5:	83 c4 10             	add    $0x10,%esp
80105df8:	31 c0                	xor    %eax,%eax
}
80105dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dfd:	5b                   	pop    %ebx
80105dfe:	5e                   	pop    %esi
80105dff:	5f                   	pop    %edi
80105e00:	5d                   	pop    %ebp
80105e01:	c3                   	ret    
80105e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105e08:	83 ec 0c             	sub    $0xc,%esp
80105e0b:	56                   	push   %esi
80105e0c:	e8 ff ba ff ff       	call   80101910 <iunlockput>
    goto bad;
80105e11:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105e14:	83 ec 0c             	sub    $0xc,%esp
80105e17:	53                   	push   %ebx
80105e18:	e8 63 b8 ff ff       	call   80101680 <ilock>
  ip->nlink--;
80105e1d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e22:	89 1c 24             	mov    %ebx,(%esp)
80105e25:	e8 a6 b7 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105e2a:	89 1c 24             	mov    %ebx,(%esp)
80105e2d:	e8 de ba ff ff       	call   80101910 <iunlockput>
  end_op();
80105e32:	e8 d9 cd ff ff       	call   80102c10 <end_op>
  return -1;
80105e37:	83 c4 10             	add    $0x10,%esp
}
80105e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e42:	5b                   	pop    %ebx
80105e43:	5e                   	pop    %esi
80105e44:	5f                   	pop    %edi
80105e45:	5d                   	pop    %ebp
80105e46:	c3                   	ret    
    iunlockput(ip);
80105e47:	83 ec 0c             	sub    $0xc,%esp
80105e4a:	53                   	push   %ebx
80105e4b:	e8 c0 ba ff ff       	call   80101910 <iunlockput>
    end_op();
80105e50:	e8 bb cd ff ff       	call   80102c10 <end_op>
    return -1;
80105e55:	83 c4 10             	add    $0x10,%esp
80105e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5d:	eb 9b                	jmp    80105dfa <sys_link+0xda>
    end_op();
80105e5f:	e8 ac cd ff ff       	call   80102c10 <end_op>
    return -1;
80105e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e69:	eb 8f                	jmp    80105dfa <sys_link+0xda>
80105e6b:	90                   	nop
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e70 <sys_unlink>:
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	57                   	push   %edi
80105e74:	56                   	push   %esi
80105e75:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105e76:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105e79:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105e7c:	50                   	push   %eax
80105e7d:	6a 00                	push   $0x0
80105e7f:	e8 1c fa ff ff       	call   801058a0 <argstr>
80105e84:	83 c4 10             	add    $0x10,%esp
80105e87:	85 c0                	test   %eax,%eax
80105e89:	0f 88 77 01 00 00    	js     80106006 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105e8f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105e92:	e8 09 cd ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e97:	83 ec 08             	sub    $0x8,%esp
80105e9a:	53                   	push   %ebx
80105e9b:	ff 75 c0             	pushl  -0x40(%ebp)
80105e9e:	e8 5d c0 ff ff       	call   80101f00 <nameiparent>
80105ea3:	83 c4 10             	add    $0x10,%esp
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	89 c6                	mov    %eax,%esi
80105eaa:	0f 84 60 01 00 00    	je     80106010 <sys_unlink+0x1a0>
  ilock(dp);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	50                   	push   %eax
80105eb4:	e8 c7 b7 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105eb9:	58                   	pop    %eax
80105eba:	5a                   	pop    %edx
80105ebb:	68 44 89 10 80       	push   $0x80108944
80105ec0:	53                   	push   %ebx
80105ec1:	e8 ca bc ff ff       	call   80101b90 <namecmp>
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	0f 84 03 01 00 00    	je     80105fd4 <sys_unlink+0x164>
80105ed1:	83 ec 08             	sub    $0x8,%esp
80105ed4:	68 43 89 10 80       	push   $0x80108943
80105ed9:	53                   	push   %ebx
80105eda:	e8 b1 bc ff ff       	call   80101b90 <namecmp>
80105edf:	83 c4 10             	add    $0x10,%esp
80105ee2:	85 c0                	test   %eax,%eax
80105ee4:	0f 84 ea 00 00 00    	je     80105fd4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105eea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105eed:	83 ec 04             	sub    $0x4,%esp
80105ef0:	50                   	push   %eax
80105ef1:	53                   	push   %ebx
80105ef2:	56                   	push   %esi
80105ef3:	e8 b8 bc ff ff       	call   80101bb0 <dirlookup>
80105ef8:	83 c4 10             	add    $0x10,%esp
80105efb:	85 c0                	test   %eax,%eax
80105efd:	89 c3                	mov    %eax,%ebx
80105eff:	0f 84 cf 00 00 00    	je     80105fd4 <sys_unlink+0x164>
  ilock(ip);
80105f05:	83 ec 0c             	sub    $0xc,%esp
80105f08:	50                   	push   %eax
80105f09:	e8 72 b7 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80105f0e:	83 c4 10             	add    $0x10,%esp
80105f11:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105f16:	0f 8e 10 01 00 00    	jle    8010602c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f21:	74 6d                	je     80105f90 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105f23:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f26:	83 ec 04             	sub    $0x4,%esp
80105f29:	6a 10                	push   $0x10
80105f2b:	6a 00                	push   $0x0
80105f2d:	50                   	push   %eax
80105f2e:	e8 bd f5 ff ff       	call   801054f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f33:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f36:	6a 10                	push   $0x10
80105f38:	ff 75 c4             	pushl  -0x3c(%ebp)
80105f3b:	50                   	push   %eax
80105f3c:	56                   	push   %esi
80105f3d:	e8 1e bb ff ff       	call   80101a60 <writei>
80105f42:	83 c4 20             	add    $0x20,%esp
80105f45:	83 f8 10             	cmp    $0x10,%eax
80105f48:	0f 85 eb 00 00 00    	jne    80106039 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105f4e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f53:	0f 84 97 00 00 00    	je     80105ff0 <sys_unlink+0x180>
  iunlockput(dp);
80105f59:	83 ec 0c             	sub    $0xc,%esp
80105f5c:	56                   	push   %esi
80105f5d:	e8 ae b9 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105f62:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105f67:	89 1c 24             	mov    %ebx,(%esp)
80105f6a:	e8 61 b6 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105f6f:	89 1c 24             	mov    %ebx,(%esp)
80105f72:	e8 99 b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105f77:	e8 94 cc ff ff       	call   80102c10 <end_op>
  return 0;
80105f7c:	83 c4 10             	add    $0x10,%esp
80105f7f:	31 c0                	xor    %eax,%eax
}
80105f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f84:	5b                   	pop    %ebx
80105f85:	5e                   	pop    %esi
80105f86:	5f                   	pop    %edi
80105f87:	5d                   	pop    %ebp
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f90:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105f94:	76 8d                	jbe    80105f23 <sys_unlink+0xb3>
80105f96:	bf 20 00 00 00       	mov    $0x20,%edi
80105f9b:	eb 0f                	jmp    80105fac <sys_unlink+0x13c>
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
80105fa0:	83 c7 10             	add    $0x10,%edi
80105fa3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105fa6:	0f 83 77 ff ff ff    	jae    80105f23 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fac:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105faf:	6a 10                	push   $0x10
80105fb1:	57                   	push   %edi
80105fb2:	50                   	push   %eax
80105fb3:	53                   	push   %ebx
80105fb4:	e8 a7 b9 ff ff       	call   80101960 <readi>
80105fb9:	83 c4 10             	add    $0x10,%esp
80105fbc:	83 f8 10             	cmp    $0x10,%eax
80105fbf:	75 5e                	jne    8010601f <sys_unlink+0x1af>
    if(de.inum != 0)
80105fc1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105fc6:	74 d8                	je     80105fa0 <sys_unlink+0x130>
    iunlockput(ip);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	53                   	push   %ebx
80105fcc:	e8 3f b9 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105fd1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105fd4:	83 ec 0c             	sub    $0xc,%esp
80105fd7:	56                   	push   %esi
80105fd8:	e8 33 b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105fdd:	e8 2e cc ff ff       	call   80102c10 <end_op>
  return -1;
80105fe2:	83 c4 10             	add    $0x10,%esp
80105fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fea:	eb 95                	jmp    80105f81 <sys_unlink+0x111>
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105ff0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ff5:	83 ec 0c             	sub    $0xc,%esp
80105ff8:	56                   	push   %esi
80105ff9:	e8 d2 b5 ff ff       	call   801015d0 <iupdate>
80105ffe:	83 c4 10             	add    $0x10,%esp
80106001:	e9 53 ff ff ff       	jmp    80105f59 <sys_unlink+0xe9>
    return -1;
80106006:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600b:	e9 71 ff ff ff       	jmp    80105f81 <sys_unlink+0x111>
    end_op();
80106010:	e8 fb cb ff ff       	call   80102c10 <end_op>
    return -1;
80106015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601a:	e9 62 ff ff ff       	jmp    80105f81 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010601f:	83 ec 0c             	sub    $0xc,%esp
80106022:	68 68 89 10 80       	push   $0x80108968
80106027:	e8 64 a3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010602c:	83 ec 0c             	sub    $0xc,%esp
8010602f:	68 56 89 10 80       	push   $0x80108956
80106034:	e8 57 a3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106039:	83 ec 0c             	sub    $0xc,%esp
8010603c:	68 7a 89 10 80       	push   $0x8010897a
80106041:	e8 4a a3 ff ff       	call   80100390 <panic>
80106046:	8d 76 00             	lea    0x0(%esi),%esi
80106049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106050 <sys_open>:

int
sys_open(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	57                   	push   %edi
80106054:	56                   	push   %esi
80106055:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106056:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106059:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010605c:	50                   	push   %eax
8010605d:	6a 00                	push   $0x0
8010605f:	e8 3c f8 ff ff       	call   801058a0 <argstr>
80106064:	83 c4 10             	add    $0x10,%esp
80106067:	85 c0                	test   %eax,%eax
80106069:	0f 88 1d 01 00 00    	js     8010618c <sys_open+0x13c>
8010606f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106072:	83 ec 08             	sub    $0x8,%esp
80106075:	50                   	push   %eax
80106076:	6a 01                	push   $0x1
80106078:	e8 73 f7 ff ff       	call   801057f0 <argint>
8010607d:	83 c4 10             	add    $0x10,%esp
80106080:	85 c0                	test   %eax,%eax
80106082:	0f 88 04 01 00 00    	js     8010618c <sys_open+0x13c>
    return -1;

  begin_op();
80106088:	e8 13 cb ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
8010608d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106091:	0f 85 a9 00 00 00    	jne    80106140 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106097:	83 ec 0c             	sub    $0xc,%esp
8010609a:	ff 75 e0             	pushl  -0x20(%ebp)
8010609d:	e8 3e be ff ff       	call   80101ee0 <namei>
801060a2:	83 c4 10             	add    $0x10,%esp
801060a5:	85 c0                	test   %eax,%eax
801060a7:	89 c6                	mov    %eax,%esi
801060a9:	0f 84 b2 00 00 00    	je     80106161 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801060af:	83 ec 0c             	sub    $0xc,%esp
801060b2:	50                   	push   %eax
801060b3:	e8 c8 b5 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801060b8:	83 c4 10             	add    $0x10,%esp
801060bb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801060c0:	0f 84 aa 00 00 00    	je     80106170 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060c6:	e8 b5 ac ff ff       	call   80100d80 <filealloc>
801060cb:	85 c0                	test   %eax,%eax
801060cd:	89 c7                	mov    %eax,%edi
801060cf:	0f 84 a6 00 00 00    	je     8010617b <sys_open+0x12b>
  struct proc *curproc = myproc();
801060d5:	e8 86 d7 ff ff       	call   80103860 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060da:	31 db                	xor    %ebx,%ebx
801060dc:	eb 0e                	jmp    801060ec <sys_open+0x9c>
801060de:	66 90                	xchg   %ax,%ax
801060e0:	83 c3 01             	add    $0x1,%ebx
801060e3:	83 fb 10             	cmp    $0x10,%ebx
801060e6:	0f 84 ac 00 00 00    	je     80106198 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801060ec:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801060f0:	85 d2                	test   %edx,%edx
801060f2:	75 ec                	jne    801060e0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801060f4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801060f7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801060fb:	56                   	push   %esi
801060fc:	e8 5f b6 ff ff       	call   80101760 <iunlock>
  end_op();
80106101:	e8 0a cb ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80106106:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010610c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010610f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106112:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106115:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010611c:	89 d0                	mov    %edx,%eax
8010611e:	f7 d0                	not    %eax
80106120:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106123:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106126:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106129:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010612d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106130:	89 d8                	mov    %ebx,%eax
80106132:	5b                   	pop    %ebx
80106133:	5e                   	pop    %esi
80106134:	5f                   	pop    %edi
80106135:	5d                   	pop    %ebp
80106136:	c3                   	ret    
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106146:	31 c9                	xor    %ecx,%ecx
80106148:	6a 00                	push   $0x0
8010614a:	ba 02 00 00 00       	mov    $0x2,%edx
8010614f:	e8 ec f7 ff ff       	call   80105940 <create>
    if(ip == 0){
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106159:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010615b:	0f 85 65 ff ff ff    	jne    801060c6 <sys_open+0x76>
      end_op();
80106161:	e8 aa ca ff ff       	call   80102c10 <end_op>
      return -1;
80106166:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010616b:	eb c0                	jmp    8010612d <sys_open+0xdd>
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106170:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106173:	85 c9                	test   %ecx,%ecx
80106175:	0f 84 4b ff ff ff    	je     801060c6 <sys_open+0x76>
    iunlockput(ip);
8010617b:	83 ec 0c             	sub    $0xc,%esp
8010617e:	56                   	push   %esi
8010617f:	e8 8c b7 ff ff       	call   80101910 <iunlockput>
    end_op();
80106184:	e8 87 ca ff ff       	call   80102c10 <end_op>
    return -1;
80106189:	83 c4 10             	add    $0x10,%esp
8010618c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106191:	eb 9a                	jmp    8010612d <sys_open+0xdd>
80106193:	90                   	nop
80106194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80106198:	83 ec 0c             	sub    $0xc,%esp
8010619b:	57                   	push   %edi
8010619c:	e8 9f ac ff ff       	call   80100e40 <fileclose>
801061a1:	83 c4 10             	add    $0x10,%esp
801061a4:	eb d5                	jmp    8010617b <sys_open+0x12b>
801061a6:	8d 76 00             	lea    0x0(%esi),%esi
801061a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061b6:	e8 e5 c9 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061be:	83 ec 08             	sub    $0x8,%esp
801061c1:	50                   	push   %eax
801061c2:	6a 00                	push   $0x0
801061c4:	e8 d7 f6 ff ff       	call   801058a0 <argstr>
801061c9:	83 c4 10             	add    $0x10,%esp
801061cc:	85 c0                	test   %eax,%eax
801061ce:	78 30                	js     80106200 <sys_mkdir+0x50>
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d6:	31 c9                	xor    %ecx,%ecx
801061d8:	6a 00                	push   $0x0
801061da:	ba 01 00 00 00       	mov    $0x1,%edx
801061df:	e8 5c f7 ff ff       	call   80105940 <create>
801061e4:	83 c4 10             	add    $0x10,%esp
801061e7:	85 c0                	test   %eax,%eax
801061e9:	74 15                	je     80106200 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801061eb:	83 ec 0c             	sub    $0xc,%esp
801061ee:	50                   	push   %eax
801061ef:	e8 1c b7 ff ff       	call   80101910 <iunlockput>
  end_op();
801061f4:	e8 17 ca ff ff       	call   80102c10 <end_op>
  return 0;
801061f9:	83 c4 10             	add    $0x10,%esp
801061fc:	31 c0                	xor    %eax,%eax
}
801061fe:	c9                   	leave  
801061ff:	c3                   	ret    
    end_op();
80106200:	e8 0b ca ff ff       	call   80102c10 <end_op>
    return -1;
80106205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010620a:	c9                   	leave  
8010620b:	c3                   	ret    
8010620c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106210 <sys_mknod>:

int
sys_mknod(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106216:	e8 85 c9 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010621b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010621e:	83 ec 08             	sub    $0x8,%esp
80106221:	50                   	push   %eax
80106222:	6a 00                	push   $0x0
80106224:	e8 77 f6 ff ff       	call   801058a0 <argstr>
80106229:	83 c4 10             	add    $0x10,%esp
8010622c:	85 c0                	test   %eax,%eax
8010622e:	78 60                	js     80106290 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106230:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106233:	83 ec 08             	sub    $0x8,%esp
80106236:	50                   	push   %eax
80106237:	6a 01                	push   $0x1
80106239:	e8 b2 f5 ff ff       	call   801057f0 <argint>
  if((argstr(0, &path)) < 0 ||
8010623e:	83 c4 10             	add    $0x10,%esp
80106241:	85 c0                	test   %eax,%eax
80106243:	78 4b                	js     80106290 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106245:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106248:	83 ec 08             	sub    $0x8,%esp
8010624b:	50                   	push   %eax
8010624c:	6a 02                	push   $0x2
8010624e:	e8 9d f5 ff ff       	call   801057f0 <argint>
     argint(1, &major) < 0 ||
80106253:	83 c4 10             	add    $0x10,%esp
80106256:	85 c0                	test   %eax,%eax
80106258:	78 36                	js     80106290 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010625a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010625e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106261:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106265:	ba 03 00 00 00       	mov    $0x3,%edx
8010626a:	50                   	push   %eax
8010626b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010626e:	e8 cd f6 ff ff       	call   80105940 <create>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	85 c0                	test   %eax,%eax
80106278:	74 16                	je     80106290 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010627a:	83 ec 0c             	sub    $0xc,%esp
8010627d:	50                   	push   %eax
8010627e:	e8 8d b6 ff ff       	call   80101910 <iunlockput>
  end_op();
80106283:	e8 88 c9 ff ff       	call   80102c10 <end_op>
  return 0;
80106288:	83 c4 10             	add    $0x10,%esp
8010628b:	31 c0                	xor    %eax,%eax
}
8010628d:	c9                   	leave  
8010628e:	c3                   	ret    
8010628f:	90                   	nop
    end_op();
80106290:	e8 7b c9 ff ff       	call   80102c10 <end_op>
    return -1;
80106295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010629a:	c9                   	leave  
8010629b:	c3                   	ret    
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062a0 <sys_chdir>:

int
sys_chdir(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	56                   	push   %esi
801062a4:	53                   	push   %ebx
801062a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801062a8:	e8 b3 d5 ff ff       	call   80103860 <myproc>
801062ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801062af:	e8 ec c8 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b7:	83 ec 08             	sub    $0x8,%esp
801062ba:	50                   	push   %eax
801062bb:	6a 00                	push   $0x0
801062bd:	e8 de f5 ff ff       	call   801058a0 <argstr>
801062c2:	83 c4 10             	add    $0x10,%esp
801062c5:	85 c0                	test   %eax,%eax
801062c7:	78 77                	js     80106340 <sys_chdir+0xa0>
801062c9:	83 ec 0c             	sub    $0xc,%esp
801062cc:	ff 75 f4             	pushl  -0xc(%ebp)
801062cf:	e8 0c bc ff ff       	call   80101ee0 <namei>
801062d4:	83 c4 10             	add    $0x10,%esp
801062d7:	85 c0                	test   %eax,%eax
801062d9:	89 c3                	mov    %eax,%ebx
801062db:	74 63                	je     80106340 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801062dd:	83 ec 0c             	sub    $0xc,%esp
801062e0:	50                   	push   %eax
801062e1:	e8 9a b3 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801062ee:	75 30                	jne    80106320 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801062f0:	83 ec 0c             	sub    $0xc,%esp
801062f3:	53                   	push   %ebx
801062f4:	e8 67 b4 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
801062f9:	58                   	pop    %eax
801062fa:	ff 76 68             	pushl  0x68(%esi)
801062fd:	e8 ae b4 ff ff       	call   801017b0 <iput>
  end_op();
80106302:	e8 09 c9 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80106307:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010630a:	83 c4 10             	add    $0x10,%esp
8010630d:	31 c0                	xor    %eax,%eax
}
8010630f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106312:	5b                   	pop    %ebx
80106313:	5e                   	pop    %esi
80106314:	5d                   	pop    %ebp
80106315:	c3                   	ret    
80106316:	8d 76 00             	lea    0x0(%esi),%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106320:	83 ec 0c             	sub    $0xc,%esp
80106323:	53                   	push   %ebx
80106324:	e8 e7 b5 ff ff       	call   80101910 <iunlockput>
    end_op();
80106329:	e8 e2 c8 ff ff       	call   80102c10 <end_op>
    return -1;
8010632e:	83 c4 10             	add    $0x10,%esp
80106331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106336:	eb d7                	jmp    8010630f <sys_chdir+0x6f>
80106338:	90                   	nop
80106339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106340:	e8 cb c8 ff ff       	call   80102c10 <end_op>
    return -1;
80106345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634a:	eb c3                	jmp    8010630f <sys_chdir+0x6f>
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106350 <sys_exec>:

int
sys_exec(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	57                   	push   %edi
80106354:	56                   	push   %esi
80106355:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106356:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010635c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106362:	50                   	push   %eax
80106363:	6a 00                	push   $0x0
80106365:	e8 36 f5 ff ff       	call   801058a0 <argstr>
8010636a:	83 c4 10             	add    $0x10,%esp
8010636d:	85 c0                	test   %eax,%eax
8010636f:	0f 88 87 00 00 00    	js     801063fc <sys_exec+0xac>
80106375:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010637b:	83 ec 08             	sub    $0x8,%esp
8010637e:	50                   	push   %eax
8010637f:	6a 01                	push   $0x1
80106381:	e8 6a f4 ff ff       	call   801057f0 <argint>
80106386:	83 c4 10             	add    $0x10,%esp
80106389:	85 c0                	test   %eax,%eax
8010638b:	78 6f                	js     801063fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010638d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106393:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106396:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106398:	68 80 00 00 00       	push   $0x80
8010639d:	6a 00                	push   $0x0
8010639f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801063a5:	50                   	push   %eax
801063a6:	e8 45 f1 ff ff       	call   801054f0 <memset>
801063ab:	83 c4 10             	add    $0x10,%esp
801063ae:	eb 2c                	jmp    801063dc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801063b0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801063b6:	85 c0                	test   %eax,%eax
801063b8:	74 56                	je     80106410 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801063ba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801063c0:	83 ec 08             	sub    $0x8,%esp
801063c3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801063c6:	52                   	push   %edx
801063c7:	50                   	push   %eax
801063c8:	e8 b3 f3 ff ff       	call   80105780 <fetchstr>
801063cd:	83 c4 10             	add    $0x10,%esp
801063d0:	85 c0                	test   %eax,%eax
801063d2:	78 28                	js     801063fc <sys_exec+0xac>
  for(i=0;; i++){
801063d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801063d7:	83 fb 20             	cmp    $0x20,%ebx
801063da:	74 20                	je     801063fc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063dc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801063e2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801063e9:	83 ec 08             	sub    $0x8,%esp
801063ec:	57                   	push   %edi
801063ed:	01 f0                	add    %esi,%eax
801063ef:	50                   	push   %eax
801063f0:	e8 4b f3 ff ff       	call   80105740 <fetchint>
801063f5:	83 c4 10             	add    $0x10,%esp
801063f8:	85 c0                	test   %eax,%eax
801063fa:	79 b4                	jns    801063b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801063fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801063ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106404:	5b                   	pop    %ebx
80106405:	5e                   	pop    %esi
80106406:	5f                   	pop    %edi
80106407:	5d                   	pop    %ebp
80106408:	c3                   	ret    
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106410:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106416:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106419:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106420:	00 00 00 00 
  return exec(path, argv);
80106424:	50                   	push   %eax
80106425:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010642b:	e8 e0 a5 ff ff       	call   80100a10 <exec>
80106430:	83 c4 10             	add    $0x10,%esp
}
80106433:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106436:	5b                   	pop    %ebx
80106437:	5e                   	pop    %esi
80106438:	5f                   	pop    %edi
80106439:	5d                   	pop    %ebp
8010643a:	c3                   	ret    
8010643b:	90                   	nop
8010643c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106440 <sys_pipe>:

int
sys_pipe(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	57                   	push   %edi
80106444:	56                   	push   %esi
80106445:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106446:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106449:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010644c:	6a 08                	push   $0x8
8010644e:	50                   	push   %eax
8010644f:	6a 00                	push   $0x0
80106451:	e8 ea f3 ff ff       	call   80105840 <argptr>
80106456:	83 c4 10             	add    $0x10,%esp
80106459:	85 c0                	test   %eax,%eax
8010645b:	0f 88 ae 00 00 00    	js     8010650f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106461:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106464:	83 ec 08             	sub    $0x8,%esp
80106467:	50                   	push   %eax
80106468:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010646b:	50                   	push   %eax
8010646c:	e8 cf cd ff ff       	call   80103240 <pipealloc>
80106471:	83 c4 10             	add    $0x10,%esp
80106474:	85 c0                	test   %eax,%eax
80106476:	0f 88 93 00 00 00    	js     8010650f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010647c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010647f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106481:	e8 da d3 ff ff       	call   80103860 <myproc>
80106486:	eb 10                	jmp    80106498 <sys_pipe+0x58>
80106488:	90                   	nop
80106489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106490:	83 c3 01             	add    $0x1,%ebx
80106493:	83 fb 10             	cmp    $0x10,%ebx
80106496:	74 60                	je     801064f8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106498:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010649c:	85 f6                	test   %esi,%esi
8010649e:	75 f0                	jne    80106490 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801064a0:	8d 73 08             	lea    0x8(%ebx),%esi
801064a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801064aa:	e8 b1 d3 ff ff       	call   80103860 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064af:	31 d2                	xor    %edx,%edx
801064b1:	eb 0d                	jmp    801064c0 <sys_pipe+0x80>
801064b3:	90                   	nop
801064b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064b8:	83 c2 01             	add    $0x1,%edx
801064bb:	83 fa 10             	cmp    $0x10,%edx
801064be:	74 28                	je     801064e8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801064c0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801064c4:	85 c9                	test   %ecx,%ecx
801064c6:	75 f0                	jne    801064b8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801064c8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801064cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064cf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801064d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064d4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801064d7:	31 c0                	xor    %eax,%eax
}
801064d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064dc:	5b                   	pop    %ebx
801064dd:	5e                   	pop    %esi
801064de:	5f                   	pop    %edi
801064df:	5d                   	pop    %ebp
801064e0:	c3                   	ret    
801064e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801064e8:	e8 73 d3 ff ff       	call   80103860 <myproc>
801064ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801064f4:	00 
801064f5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801064f8:	83 ec 0c             	sub    $0xc,%esp
801064fb:	ff 75 e0             	pushl  -0x20(%ebp)
801064fe:	e8 3d a9 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106503:	58                   	pop    %eax
80106504:	ff 75 e4             	pushl  -0x1c(%ebp)
80106507:	e8 34 a9 ff ff       	call   80100e40 <fileclose>
    return -1;
8010650c:	83 c4 10             	add    $0x10,%esp
8010650f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106514:	eb c3                	jmp    801064d9 <sys_pipe+0x99>
80106516:	66 90                	xchg   %ax,%ax
80106518:	66 90                	xchg   %ax,%ax
8010651a:	66 90                	xchg   %ax,%ax
8010651c:	66 90                	xchg   %ax,%ax
8010651e:	66 90                	xchg   %ax,%ax

80106520 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106523:	5d                   	pop    %ebp
  return fork();
80106524:	e9 d7 d4 ff ff       	jmp    80103a00 <fork>
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106530 <sys_exit>:

int
sys_exit(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	83 ec 08             	sub    $0x8,%esp
  exit();
80106536:	e8 05 e6 ff ff       	call   80104b40 <exit>
  return 0;  // not reached
}
8010653b:	31 c0                	xor    %eax,%eax
8010653d:	c9                   	leave  
8010653e:	c3                   	ret    
8010653f:	90                   	nop

80106540 <sys_wait>:

int
sys_wait(void)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106543:	5d                   	pop    %ebp
  return wait();
80106544:	e9 47 e8 ff ff       	jmp    80104d90 <wait>
80106549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106550 <sys_cps>:

int sys_cps(void){
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
	return cps();
}
80106553:	5d                   	pop    %ebp
	return cps();
80106554:	e9 c7 d5 ff ff       	jmp    80103b20 <cps>
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106560 <sys_getpinfo>:

int sys_getpinfo(void){
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 1c             	sub    $0x1c,%esp
	struct proc_stat*process_stat;
	int here_pid;
	if(argptr(0, (char**)&process_stat, sizeof(struct proc_stat)) < 0)
80106566:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106569:	6a 24                	push   $0x24
8010656b:	50                   	push   %eax
8010656c:	6a 00                	push   $0x0
8010656e:	e8 cd f2 ff ff       	call   80105840 <argptr>
80106573:	83 c4 10             	add    $0x10,%esp
80106576:	85 c0                	test   %eax,%eax
80106578:	78 2e                	js     801065a8 <sys_getpinfo+0x48>
    return -1;
	if(argint(1, &here_pid) < 0)
8010657a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010657d:	83 ec 08             	sub    $0x8,%esp
80106580:	50                   	push   %eax
80106581:	6a 01                	push   $0x1
80106583:	e8 68 f2 ff ff       	call   801057f0 <argint>
80106588:	83 c4 10             	add    $0x10,%esp
8010658b:	85 c0                	test   %eax,%eax
8010658d:	78 19                	js     801065a8 <sys_getpinfo+0x48>
    return -1;
	return getpinfo(process_stat,here_pid);
8010658f:	83 ec 08             	sub    $0x8,%esp
80106592:	ff 75 f4             	pushl  -0xc(%ebp)
80106595:	ff 75 f0             	pushl  -0x10(%ebp)
80106598:	e8 03 d7 ff ff       	call   80103ca0 <getpinfo>
8010659d:	83 c4 10             	add    $0x10,%esp
}
801065a0:	c9                   	leave  
801065a1:	c3                   	ret    
801065a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801065a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065ad:	c9                   	leave  
801065ae:	c3                   	ret    
801065af:	90                   	nop

801065b0 <sys_waitx>:

int 
sys_waitx(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime;
  int *rtime;
  
  if(argptr(0, (char**)&wtime, sizeof(int)) < 0)
801065b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065b9:	6a 04                	push   $0x4
801065bb:	50                   	push   %eax
801065bc:	6a 00                	push   $0x0
801065be:	e8 7d f2 ff ff       	call   80105840 <argptr>
801065c3:	83 c4 10             	add    $0x10,%esp
801065c6:	85 c0                	test   %eax,%eax
801065c8:	78 2e                	js     801065f8 <sys_waitx+0x48>
    return -1;

  if(argptr(1, (char**)&rtime, sizeof(int)) < 0)
801065ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065cd:	83 ec 04             	sub    $0x4,%esp
801065d0:	6a 04                	push   $0x4
801065d2:	50                   	push   %eax
801065d3:	6a 01                	push   $0x1
801065d5:	e8 66 f2 ff ff       	call   80105840 <argptr>
801065da:	83 c4 10             	add    $0x10,%esp
801065dd:	85 c0                	test   %eax,%eax
801065df:	78 17                	js     801065f8 <sys_waitx+0x48>
    return -1;

  return waitx(wtime, rtime);
801065e1:	83 ec 08             	sub    $0x8,%esp
801065e4:	ff 75 f4             	pushl  -0xc(%ebp)
801065e7:	ff 75 f0             	pushl  -0x10(%ebp)
801065ea:	e8 a1 e8 ff ff       	call   80104e90 <waitx>
801065ef:	83 c4 10             	add    $0x10,%esp
}
801065f2:	c9                   	leave  
801065f3:	c3                   	ret    
801065f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801065f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065fd:	c9                   	leave  
801065fe:	c3                   	ret    
801065ff:	90                   	nop

80106600 <sys_set_priority>:

int
sys_set_priority(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
80106606:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106609:	50                   	push   %eax
8010660a:	6a 00                	push   $0x0
8010660c:	e8 df f1 ff ff       	call   801057f0 <argint>
80106611:	83 c4 10             	add    $0x10,%esp
80106614:	85 c0                	test   %eax,%eax
80106616:	78 28                	js     80106640 <sys_set_priority+0x40>
    return -1;
  if(argint(1, &pr) < 0)
80106618:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010661b:	83 ec 08             	sub    $0x8,%esp
8010661e:	50                   	push   %eax
8010661f:	6a 01                	push   $0x1
80106621:	e8 ca f1 ff ff       	call   801057f0 <argint>
80106626:	83 c4 10             	add    $0x10,%esp
80106629:	85 c0                	test   %eax,%eax
8010662b:	78 13                	js     80106640 <sys_set_priority+0x40>
    return -1;

  return set_priority( pid, pr );
8010662d:	83 ec 08             	sub    $0x8,%esp
80106630:	ff 75 f4             	pushl  -0xc(%ebp)
80106633:	ff 75 f0             	pushl  -0x10(%ebp)
80106636:	e8 f5 d5 ff ff       	call   80103c30 <set_priority>
8010663b:	83 c4 10             	add    $0x10,%esp
}
8010663e:	c9                   	leave  
8010663f:	c3                   	ret    
    return -1;
80106640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106645:	c9                   	leave  
80106646:	c3                   	ret    
80106647:	89 f6                	mov    %esi,%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106650 <sys_kill>:

int
sys_kill(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106656:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106659:	50                   	push   %eax
8010665a:	6a 00                	push   $0x0
8010665c:	e8 8f f1 ff ff       	call   801057f0 <argint>
80106661:	83 c4 10             	add    $0x10,%esp
80106664:	85 c0                	test   %eax,%eax
80106666:	78 18                	js     80106680 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106668:	83 ec 0c             	sub    $0xc,%esp
8010666b:	ff 75 f4             	pushl  -0xc(%ebp)
8010666e:	e8 ad e9 ff ff       	call   80105020 <kill>
80106673:	83 c4 10             	add    $0x10,%esp
}
80106676:	c9                   	leave  
80106677:	c3                   	ret    
80106678:	90                   	nop
80106679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106685:	c9                   	leave  
80106686:	c3                   	ret    
80106687:	89 f6                	mov    %esi,%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106690 <sys_getpid>:

int
sys_getpid(void)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106696:	e8 c5 d1 ff ff       	call   80103860 <myproc>
8010669b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010669e:	c9                   	leave  
8010669f:	c3                   	ret    

801066a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801066a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801066aa:	50                   	push   %eax
801066ab:	6a 00                	push   $0x0
801066ad:	e8 3e f1 ff ff       	call   801057f0 <argint>
801066b2:	83 c4 10             	add    $0x10,%esp
801066b5:	85 c0                	test   %eax,%eax
801066b7:	78 27                	js     801066e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801066b9:	e8 a2 d1 ff ff       	call   80103860 <myproc>
  if(growproc(n) < 0)
801066be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801066c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801066c3:	ff 75 f4             	pushl  -0xc(%ebp)
801066c6:	e8 b5 d2 ff ff       	call   80103980 <growproc>
801066cb:	83 c4 10             	add    $0x10,%esp
801066ce:	85 c0                	test   %eax,%eax
801066d0:	78 0e                	js     801066e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801066d2:	89 d8                	mov    %ebx,%eax
801066d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066d7:	c9                   	leave  
801066d8:	c3                   	ret    
801066d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801066e5:	eb eb                	jmp    801066d2 <sys_sbrk+0x32>
801066e7:	89 f6                	mov    %esi,%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <sys_sleep>:

int
sys_sleep(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801066f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801066f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801066fa:	50                   	push   %eax
801066fb:	6a 00                	push   $0x0
801066fd:	e8 ee f0 ff ff       	call   801057f0 <argint>
80106702:	83 c4 10             	add    $0x10,%esp
80106705:	85 c0                	test   %eax,%eax
80106707:	0f 88 8a 00 00 00    	js     80106797 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010670d:	83 ec 0c             	sub    $0xc,%esp
80106710:	68 80 6a 11 80       	push   $0x80116a80
80106715:	e8 c6 ec ff ff       	call   801053e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010671a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010671d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106720:	8b 1d c0 72 11 80    	mov    0x801172c0,%ebx
  while(ticks - ticks0 < n){
80106726:	85 d2                	test   %edx,%edx
80106728:	75 27                	jne    80106751 <sys_sleep+0x61>
8010672a:	eb 54                	jmp    80106780 <sys_sleep+0x90>
8010672c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106730:	83 ec 08             	sub    $0x8,%esp
80106733:	68 80 6a 11 80       	push   $0x80116a80
80106738:	68 c0 72 11 80       	push   $0x801172c0
8010673d:	e8 8e e5 ff ff       	call   80104cd0 <sleep>
  while(ticks - ticks0 < n){
80106742:	a1 c0 72 11 80       	mov    0x801172c0,%eax
80106747:	83 c4 10             	add    $0x10,%esp
8010674a:	29 d8                	sub    %ebx,%eax
8010674c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010674f:	73 2f                	jae    80106780 <sys_sleep+0x90>
    if(myproc()->killed){
80106751:	e8 0a d1 ff ff       	call   80103860 <myproc>
80106756:	8b 40 24             	mov    0x24(%eax),%eax
80106759:	85 c0                	test   %eax,%eax
8010675b:	74 d3                	je     80106730 <sys_sleep+0x40>
      release(&tickslock);
8010675d:	83 ec 0c             	sub    $0xc,%esp
80106760:	68 80 6a 11 80       	push   $0x80116a80
80106765:	e8 36 ed ff ff       	call   801054a0 <release>
      return -1;
8010676a:	83 c4 10             	add    $0x10,%esp
8010676d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106775:	c9                   	leave  
80106776:	c3                   	ret    
80106777:	89 f6                	mov    %esi,%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106780:	83 ec 0c             	sub    $0xc,%esp
80106783:	68 80 6a 11 80       	push   $0x80116a80
80106788:	e8 13 ed ff ff       	call   801054a0 <release>
  return 0;
8010678d:	83 c4 10             	add    $0x10,%esp
80106790:	31 c0                	xor    %eax,%eax
}
80106792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106795:	c9                   	leave  
80106796:	c3                   	ret    
    return -1;
80106797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679c:	eb f4                	jmp    80106792 <sys_sleep+0xa2>
8010679e:	66 90                	xchg   %ax,%ax

801067a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	53                   	push   %ebx
801067a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801067a7:	68 80 6a 11 80       	push   $0x80116a80
801067ac:	e8 2f ec ff ff       	call   801053e0 <acquire>
  xticks = ticks;
801067b1:	8b 1d c0 72 11 80    	mov    0x801172c0,%ebx
  release(&tickslock);
801067b7:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
801067be:	e8 dd ec ff ff       	call   801054a0 <release>
  return xticks;
}
801067c3:	89 d8                	mov    %ebx,%eax
801067c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067c8:	c9                   	leave  
801067c9:	c3                   	ret    

801067ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067ca:	1e                   	push   %ds
  pushl %es
801067cb:	06                   	push   %es
  pushl %fs
801067cc:	0f a0                	push   %fs
  pushl %gs
801067ce:	0f a8                	push   %gs
  pushal
801067d0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067d9:	54                   	push   %esp
  call trap
801067da:	e8 c1 00 00 00       	call   801068a0 <trap>
  addl $4, %esp
801067df:	83 c4 04             	add    $0x4,%esp

801067e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067e2:	61                   	popa   
  popl %gs
801067e3:	0f a9                	pop    %gs
  popl %fs
801067e5:	0f a1                	pop    %fs
  popl %es
801067e7:	07                   	pop    %es
  popl %ds
801067e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067e9:	83 c4 08             	add    $0x8,%esp
  iret
801067ec:	cf                   	iret   
801067ed:	66 90                	xchg   %ax,%ax
801067ef:	90                   	nop

801067f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801067f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801067f1:	31 c0                	xor    %eax,%eax
{
801067f3:	89 e5                	mov    %esp,%ebp
801067f5:	83 ec 08             	sub    $0x8,%esp
801067f8:	90                   	nop
801067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106800:	8b 14 85 30 b0 10 80 	mov    -0x7fef4fd0(,%eax,4),%edx
80106807:	c7 04 c5 c2 6a 11 80 	movl   $0x8e000008,-0x7fee953e(,%eax,8)
8010680e:	08 00 00 8e 
80106812:	66 89 14 c5 c0 6a 11 	mov    %dx,-0x7fee9540(,%eax,8)
80106819:	80 
8010681a:	c1 ea 10             	shr    $0x10,%edx
8010681d:	66 89 14 c5 c6 6a 11 	mov    %dx,-0x7fee953a(,%eax,8)
80106824:	80 
  for(i = 0; i < 256; i++)
80106825:	83 c0 01             	add    $0x1,%eax
80106828:	3d 00 01 00 00       	cmp    $0x100,%eax
8010682d:	75 d1                	jne    80106800 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010682f:	a1 30 b1 10 80       	mov    0x8010b130,%eax

  initlock(&tickslock, "time");
80106834:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106837:	c7 05 c2 6c 11 80 08 	movl   $0xef000008,0x80116cc2
8010683e:	00 00 ef 
  initlock(&tickslock, "time");
80106841:	68 89 89 10 80       	push   $0x80108989
80106846:	68 80 6a 11 80       	push   $0x80116a80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010684b:	66 a3 c0 6c 11 80    	mov    %ax,0x80116cc0
80106851:	c1 e8 10             	shr    $0x10,%eax
80106854:	66 a3 c6 6c 11 80    	mov    %ax,0x80116cc6
  initlock(&tickslock, "time");
8010685a:	e8 41 ea ff ff       	call   801052a0 <initlock>
}
8010685f:	83 c4 10             	add    $0x10,%esp
80106862:	c9                   	leave  
80106863:	c3                   	ret    
80106864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010686a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106870 <idtinit>:

void
idtinit(void)
{
80106870:	55                   	push   %ebp
  pd[0] = size-1;
80106871:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106876:	89 e5                	mov    %esp,%ebp
80106878:	83 ec 10             	sub    $0x10,%esp
8010687b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010687f:	b8 c0 6a 11 80       	mov    $0x80116ac0,%eax
80106884:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106888:	c1 e8 10             	shr    $0x10,%eax
8010688b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010688f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106892:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106895:	c9                   	leave  
80106896:	c3                   	ret    
80106897:	89 f6                	mov    %esi,%esi
80106899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
801068a5:	53                   	push   %ebx
801068a6:	83 ec 1c             	sub    $0x1c,%esp
801068a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801068ac:	8b 47 30             	mov    0x30(%edi),%eax
801068af:	83 f8 40             	cmp    $0x40,%eax
801068b2:	0f 84 f0 00 00 00    	je     801069a8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801068b8:	83 e8 20             	sub    $0x20,%eax
801068bb:	83 f8 1f             	cmp    $0x1f,%eax
801068be:	77 10                	ja     801068d0 <trap+0x30>
801068c0:	ff 24 85 30 8a 10 80 	jmp    *-0x7fef75d0(,%eax,4)
801068c7:	89 f6                	mov    %esi,%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801068d0:	e8 8b cf ff ff       	call   80103860 <myproc>
801068d5:	85 c0                	test   %eax,%eax
801068d7:	8b 5f 38             	mov    0x38(%edi),%ebx
801068da:	0f 84 6d 02 00 00    	je     80106b4d <trap+0x2ad>
801068e0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801068e4:	0f 84 63 02 00 00    	je     80106b4d <trap+0x2ad>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068ea:	0f 20 d1             	mov    %cr2,%ecx
801068ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068f0:	e8 4b cf ff ff       	call   80103840 <cpuid>
801068f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068f8:	8b 47 34             	mov    0x34(%edi),%eax
801068fb:	8b 77 30             	mov    0x30(%edi),%esi
801068fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106901:	e8 5a cf ff ff       	call   80103860 <myproc>
80106906:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106909:	e8 52 cf ff ff       	call   80103860 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010690e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106911:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106914:	51                   	push   %ecx
80106915:	53                   	push   %ebx
80106916:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106917:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010691a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010691d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010691e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106921:	52                   	push   %edx
80106922:	ff 70 10             	pushl  0x10(%eax)
80106925:	68 ec 89 10 80       	push   $0x801089ec
8010692a:	e8 31 9d ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010692f:	83 c4 20             	add    $0x20,%esp
80106932:	e8 29 cf ff ff       	call   80103860 <myproc>
80106937:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010693e:	e8 1d cf ff ff       	call   80103860 <myproc>
80106943:	85 c0                	test   %eax,%eax
80106945:	74 1d                	je     80106964 <trap+0xc4>
80106947:	e8 14 cf ff ff       	call   80103860 <myproc>
8010694c:	8b 50 24             	mov    0x24(%eax),%edx
8010694f:	85 d2                	test   %edx,%edx
80106951:	74 11                	je     80106964 <trap+0xc4>
80106953:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106957:	83 e0 03             	and    $0x3,%eax
8010695a:	66 83 f8 03          	cmp    $0x3,%ax
8010695e:	0f 84 4c 01 00 00    	je     80106ab0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106964:	e8 f7 ce ff ff       	call   80103860 <myproc>
80106969:	85 c0                	test   %eax,%eax
8010696b:	74 0b                	je     80106978 <trap+0xd8>
8010696d:	e8 ee ce ff ff       	call   80103860 <myproc>
80106972:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106976:	74 68                	je     801069e0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106978:	e8 e3 ce ff ff       	call   80103860 <myproc>
8010697d:	85 c0                	test   %eax,%eax
8010697f:	74 19                	je     8010699a <trap+0xfa>
80106981:	e8 da ce ff ff       	call   80103860 <myproc>
80106986:	8b 40 24             	mov    0x24(%eax),%eax
80106989:	85 c0                	test   %eax,%eax
8010698b:	74 0d                	je     8010699a <trap+0xfa>
8010698d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106991:	83 e0 03             	and    $0x3,%eax
80106994:	66 83 f8 03          	cmp    $0x3,%ax
80106998:	74 37                	je     801069d1 <trap+0x131>
    exit();
}
8010699a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010699d:	5b                   	pop    %ebx
8010699e:	5e                   	pop    %esi
8010699f:	5f                   	pop    %edi
801069a0:	5d                   	pop    %ebp
801069a1:	c3                   	ret    
801069a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801069a8:	e8 b3 ce ff ff       	call   80103860 <myproc>
801069ad:	8b 58 24             	mov    0x24(%eax),%ebx
801069b0:	85 db                	test   %ebx,%ebx
801069b2:	0f 85 e8 00 00 00    	jne    80106aa0 <trap+0x200>
    myproc()->tf = tf;
801069b8:	e8 a3 ce ff ff       	call   80103860 <myproc>
801069bd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801069c0:	e8 1b ef ff ff       	call   801058e0 <syscall>
    if(myproc()->killed)
801069c5:	e8 96 ce ff ff       	call   80103860 <myproc>
801069ca:	8b 48 24             	mov    0x24(%eax),%ecx
801069cd:	85 c9                	test   %ecx,%ecx
801069cf:	74 c9                	je     8010699a <trap+0xfa>
}
801069d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069d4:	5b                   	pop    %ebx
801069d5:	5e                   	pop    %esi
801069d6:	5f                   	pop    %edi
801069d7:	5d                   	pop    %ebp
      exit();
801069d8:	e9 63 e1 ff ff       	jmp    80104b40 <exit>
801069dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801069e0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801069e4:	75 92                	jne    80106978 <trap+0xd8>
    yield();
801069e6:	e8 95 e2 ff ff       	call   80104c80 <yield>
801069eb:	eb 8b                	jmp    80106978 <trap+0xd8>
801069ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801069f0:	e8 4b ce ff ff       	call   80103840 <cpuid>
801069f5:	85 c0                	test   %eax,%eax
801069f7:	0f 84 c3 00 00 00    	je     80106ac0 <trap+0x220>
    lapiceoi();
801069fd:	e8 4e bd ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a02:	e8 59 ce ff ff       	call   80103860 <myproc>
80106a07:	85 c0                	test   %eax,%eax
80106a09:	0f 85 38 ff ff ff    	jne    80106947 <trap+0xa7>
80106a0f:	e9 50 ff ff ff       	jmp    80106964 <trap+0xc4>
80106a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106a18:	e8 f3 bb ff ff       	call   80102610 <kbdintr>
    lapiceoi();
80106a1d:	e8 2e bd ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a22:	e8 39 ce ff ff       	call   80103860 <myproc>
80106a27:	85 c0                	test   %eax,%eax
80106a29:	0f 85 18 ff ff ff    	jne    80106947 <trap+0xa7>
80106a2f:	e9 30 ff ff ff       	jmp    80106964 <trap+0xc4>
80106a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106a38:	e8 b3 02 00 00       	call   80106cf0 <uartintr>
    lapiceoi();
80106a3d:	e8 0e bd ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a42:	e8 19 ce ff ff       	call   80103860 <myproc>
80106a47:	85 c0                	test   %eax,%eax
80106a49:	0f 85 f8 fe ff ff    	jne    80106947 <trap+0xa7>
80106a4f:	e9 10 ff ff ff       	jmp    80106964 <trap+0xc4>
80106a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a58:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106a5c:	8b 77 38             	mov    0x38(%edi),%esi
80106a5f:	e8 dc cd ff ff       	call   80103840 <cpuid>
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	50                   	push   %eax
80106a67:	68 94 89 10 80       	push   $0x80108994
80106a6c:	e8 ef 9b ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106a71:	e8 da bc ff ff       	call   80102750 <lapiceoi>
    break;
80106a76:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a79:	e8 e2 cd ff ff       	call   80103860 <myproc>
80106a7e:	85 c0                	test   %eax,%eax
80106a80:	0f 85 c1 fe ff ff    	jne    80106947 <trap+0xa7>
80106a86:	e9 d9 fe ff ff       	jmp    80106964 <trap+0xc4>
80106a8b:	90                   	nop
80106a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106a90:	e8 eb b5 ff ff       	call   80102080 <ideintr>
80106a95:	e9 63 ff ff ff       	jmp    801069fd <trap+0x15d>
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106aa0:	e8 9b e0 ff ff       	call   80104b40 <exit>
80106aa5:	e9 0e ff ff ff       	jmp    801069b8 <trap+0x118>
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106ab0:	e8 8b e0 ff ff       	call   80104b40 <exit>
80106ab5:	e9 aa fe ff ff       	jmp    80106964 <trap+0xc4>
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106ac0:	83 ec 0c             	sub    $0xc,%esp
80106ac3:	68 80 6a 11 80       	push   $0x80116a80
80106ac8:	e8 13 e9 ff ff       	call   801053e0 <acquire>
      ticks++;
80106acd:	83 05 c0 72 11 80 01 	addl   $0x1,0x801172c0
      if(myproc()) 
80106ad4:	e8 87 cd ff ff       	call   80103860 <myproc>
80106ad9:	83 c4 10             	add    $0x10,%esp
80106adc:	85 c0                	test   %eax,%eax
80106ade:	74 16                	je     80106af6 <trap+0x256>
        if(myproc()->state == RUNNING){
80106ae0:	e8 7b cd ff ff       	call   80103860 <myproc>
80106ae5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106ae9:	74 2c                	je     80106b17 <trap+0x277>
        else if(myproc()->state == SLEEPING)
80106aeb:	e8 70 cd ff ff       	call   80103860 <myproc>
80106af0:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80106af4:	74 49                	je     80106b3f <trap+0x29f>
      wakeup(&ticks);
80106af6:	83 ec 0c             	sub    $0xc,%esp
80106af9:	68 c0 72 11 80       	push   $0x801172c0
80106afe:	e8 bd e4 ff ff       	call   80104fc0 <wakeup>
      release(&tickslock);
80106b03:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
80106b0a:	e8 91 e9 ff ff       	call   801054a0 <release>
80106b0f:	83 c4 10             	add    $0x10,%esp
80106b12:	e9 e6 fe ff ff       	jmp    801069fd <trap+0x15d>
          myproc()->ticks[myproc()->current_queue]++;     
80106b17:	e8 44 cd ff ff       	call   80103860 <myproc>
80106b1c:	89 c3                	mov    %eax,%ebx
80106b1e:	e8 3d cd ff ff       	call   80103860 <myproc>
80106b23:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80106b29:	83 84 83 90 00 00 00 	addl   $0x1,0x90(%ebx,%eax,4)
80106b30:	01 
          myproc()->rtime++;
80106b31:	e8 2a cd ff ff       	call   80103860 <myproc>
80106b36:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
80106b3d:	eb b7                	jmp    80106af6 <trap+0x256>
          myproc()->iotime++;
80106b3f:	e8 1c cd ff ff       	call   80103860 <myproc>
80106b44:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
80106b4b:	eb a9                	jmp    80106af6 <trap+0x256>
80106b4d:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b50:	e8 eb cc ff ff       	call   80103840 <cpuid>
80106b55:	83 ec 0c             	sub    $0xc,%esp
80106b58:	56                   	push   %esi
80106b59:	53                   	push   %ebx
80106b5a:	50                   	push   %eax
80106b5b:	ff 77 30             	pushl  0x30(%edi)
80106b5e:	68 b8 89 10 80       	push   $0x801089b8
80106b63:	e8 f8 9a ff ff       	call   80100660 <cprintf>
      panic("trap");
80106b68:	83 c4 14             	add    $0x14,%esp
80106b6b:	68 8e 89 10 80       	push   $0x8010898e
80106b70:	e8 1b 98 ff ff       	call   80100390 <panic>
80106b75:	66 90                	xchg   %ax,%ax
80106b77:	66 90                	xchg   %ax,%ax
80106b79:	66 90                	xchg   %ax,%ax
80106b7b:	66 90                	xchg   %ax,%ax
80106b7d:	66 90                	xchg   %ax,%ax
80106b7f:	90                   	nop

80106b80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106b80:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
{
80106b85:	55                   	push   %ebp
80106b86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	74 1c                	je     80106ba8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b92:	a8 01                	test   $0x1,%al
80106b94:	74 12                	je     80106ba8 <uartgetc+0x28>
80106b96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b9b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b9c:	0f b6 c0             	movzbl %al,%eax
}
80106b9f:	5d                   	pop    %ebp
80106ba0:	c3                   	ret    
80106ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106ba8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bad:	5d                   	pop    %ebp
80106bae:	c3                   	ret    
80106baf:	90                   	nop

80106bb0 <uartputc.part.0>:
uartputc(int c)
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
80106bb6:	89 c7                	mov    %eax,%edi
80106bb8:	bb 80 00 00 00       	mov    $0x80,%ebx
80106bbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106bc2:	83 ec 0c             	sub    $0xc,%esp
80106bc5:	eb 1b                	jmp    80106be2 <uartputc.part.0+0x32>
80106bc7:	89 f6                	mov    %esi,%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106bd0:	83 ec 0c             	sub    $0xc,%esp
80106bd3:	6a 0a                	push   $0xa
80106bd5:	e8 96 bb ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bda:	83 c4 10             	add    $0x10,%esp
80106bdd:	83 eb 01             	sub    $0x1,%ebx
80106be0:	74 07                	je     80106be9 <uartputc.part.0+0x39>
80106be2:	89 f2                	mov    %esi,%edx
80106be4:	ec                   	in     (%dx),%al
80106be5:	a8 20                	test   $0x20,%al
80106be7:	74 e7                	je     80106bd0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106be9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bee:	89 f8                	mov    %edi,%eax
80106bf0:	ee                   	out    %al,(%dx)
}
80106bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf4:	5b                   	pop    %ebx
80106bf5:	5e                   	pop    %esi
80106bf6:	5f                   	pop    %edi
80106bf7:	5d                   	pop    %ebp
80106bf8:	c3                   	ret    
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <uartinit>:
{
80106c00:	55                   	push   %ebp
80106c01:	31 c9                	xor    %ecx,%ecx
80106c03:	89 c8                	mov    %ecx,%eax
80106c05:	89 e5                	mov    %esp,%ebp
80106c07:	57                   	push   %edi
80106c08:	56                   	push   %esi
80106c09:	53                   	push   %ebx
80106c0a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106c0f:	89 da                	mov    %ebx,%edx
80106c11:	83 ec 0c             	sub    $0xc,%esp
80106c14:	ee                   	out    %al,(%dx)
80106c15:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106c1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106c1f:	89 fa                	mov    %edi,%edx
80106c21:	ee                   	out    %al,(%dx)
80106c22:	b8 0c 00 00 00       	mov    $0xc,%eax
80106c27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c2c:	ee                   	out    %al,(%dx)
80106c2d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106c32:	89 c8                	mov    %ecx,%eax
80106c34:	89 f2                	mov    %esi,%edx
80106c36:	ee                   	out    %al,(%dx)
80106c37:	b8 03 00 00 00       	mov    $0x3,%eax
80106c3c:	89 fa                	mov    %edi,%edx
80106c3e:	ee                   	out    %al,(%dx)
80106c3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106c44:	89 c8                	mov    %ecx,%eax
80106c46:	ee                   	out    %al,(%dx)
80106c47:	b8 01 00 00 00       	mov    $0x1,%eax
80106c4c:	89 f2                	mov    %esi,%edx
80106c4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c54:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106c55:	3c ff                	cmp    $0xff,%al
80106c57:	74 5a                	je     80106cb3 <uartinit+0xb3>
  uart = 1;
80106c59:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
80106c60:	00 00 00 
80106c63:	89 da                	mov    %ebx,%edx
80106c65:	ec                   	in     (%dx),%al
80106c66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c6b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106c6c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106c6f:	bb b0 8a 10 80       	mov    $0x80108ab0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106c74:	6a 00                	push   $0x0
80106c76:	6a 04                	push   $0x4
80106c78:	e8 53 b6 ff ff       	call   801022d0 <ioapicenable>
80106c7d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c80:	b8 78 00 00 00       	mov    $0x78,%eax
80106c85:	eb 13                	jmp    80106c9a <uartinit+0x9a>
80106c87:	89 f6                	mov    %esi,%esi
80106c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c90:	83 c3 01             	add    $0x1,%ebx
80106c93:	0f be 03             	movsbl (%ebx),%eax
80106c96:	84 c0                	test   %al,%al
80106c98:	74 19                	je     80106cb3 <uartinit+0xb3>
  if(!uart)
80106c9a:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
80106ca0:	85 d2                	test   %edx,%edx
80106ca2:	74 ec                	je     80106c90 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106ca4:	83 c3 01             	add    $0x1,%ebx
80106ca7:	e8 04 ff ff ff       	call   80106bb0 <uartputc.part.0>
80106cac:	0f be 03             	movsbl (%ebx),%eax
80106caf:	84 c0                	test   %al,%al
80106cb1:	75 e7                	jne    80106c9a <uartinit+0x9a>
}
80106cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb6:	5b                   	pop    %ebx
80106cb7:	5e                   	pop    %esi
80106cb8:	5f                   	pop    %edi
80106cb9:	5d                   	pop    %ebp
80106cba:	c3                   	ret    
80106cbb:	90                   	nop
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <uartputc>:
  if(!uart)
80106cc0:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
80106cc6:	55                   	push   %ebp
80106cc7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106cc9:	85 d2                	test   %edx,%edx
{
80106ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106cce:	74 10                	je     80106ce0 <uartputc+0x20>
}
80106cd0:	5d                   	pop    %ebp
80106cd1:	e9 da fe ff ff       	jmp    80106bb0 <uartputc.part.0>
80106cd6:	8d 76 00             	lea    0x0(%esi),%esi
80106cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ce0:	5d                   	pop    %ebp
80106ce1:	c3                   	ret    
80106ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <uartintr>:

void
uartintr(void)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106cf6:	68 80 6b 10 80       	push   $0x80106b80
80106cfb:	e8 10 9b ff ff       	call   80100810 <consoleintr>
}
80106d00:	83 c4 10             	add    $0x10,%esp
80106d03:	c9                   	leave  
80106d04:	c3                   	ret    

80106d05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d05:	6a 00                	push   $0x0
  pushl $0
80106d07:	6a 00                	push   $0x0
  jmp alltraps
80106d09:	e9 bc fa ff ff       	jmp    801067ca <alltraps>

80106d0e <vector1>:
.globl vector1
vector1:
  pushl $0
80106d0e:	6a 00                	push   $0x0
  pushl $1
80106d10:	6a 01                	push   $0x1
  jmp alltraps
80106d12:	e9 b3 fa ff ff       	jmp    801067ca <alltraps>

80106d17 <vector2>:
.globl vector2
vector2:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $2
80106d19:	6a 02                	push   $0x2
  jmp alltraps
80106d1b:	e9 aa fa ff ff       	jmp    801067ca <alltraps>

80106d20 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d20:	6a 00                	push   $0x0
  pushl $3
80106d22:	6a 03                	push   $0x3
  jmp alltraps
80106d24:	e9 a1 fa ff ff       	jmp    801067ca <alltraps>

80106d29 <vector4>:
.globl vector4
vector4:
  pushl $0
80106d29:	6a 00                	push   $0x0
  pushl $4
80106d2b:	6a 04                	push   $0x4
  jmp alltraps
80106d2d:	e9 98 fa ff ff       	jmp    801067ca <alltraps>

80106d32 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $5
80106d34:	6a 05                	push   $0x5
  jmp alltraps
80106d36:	e9 8f fa ff ff       	jmp    801067ca <alltraps>

80106d3b <vector6>:
.globl vector6
vector6:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $6
80106d3d:	6a 06                	push   $0x6
  jmp alltraps
80106d3f:	e9 86 fa ff ff       	jmp    801067ca <alltraps>

80106d44 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d44:	6a 00                	push   $0x0
  pushl $7
80106d46:	6a 07                	push   $0x7
  jmp alltraps
80106d48:	e9 7d fa ff ff       	jmp    801067ca <alltraps>

80106d4d <vector8>:
.globl vector8
vector8:
  pushl $8
80106d4d:	6a 08                	push   $0x8
  jmp alltraps
80106d4f:	e9 76 fa ff ff       	jmp    801067ca <alltraps>

80106d54 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $9
80106d56:	6a 09                	push   $0x9
  jmp alltraps
80106d58:	e9 6d fa ff ff       	jmp    801067ca <alltraps>

80106d5d <vector10>:
.globl vector10
vector10:
  pushl $10
80106d5d:	6a 0a                	push   $0xa
  jmp alltraps
80106d5f:	e9 66 fa ff ff       	jmp    801067ca <alltraps>

80106d64 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d64:	6a 0b                	push   $0xb
  jmp alltraps
80106d66:	e9 5f fa ff ff       	jmp    801067ca <alltraps>

80106d6b <vector12>:
.globl vector12
vector12:
  pushl $12
80106d6b:	6a 0c                	push   $0xc
  jmp alltraps
80106d6d:	e9 58 fa ff ff       	jmp    801067ca <alltraps>

80106d72 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d72:	6a 0d                	push   $0xd
  jmp alltraps
80106d74:	e9 51 fa ff ff       	jmp    801067ca <alltraps>

80106d79 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d79:	6a 0e                	push   $0xe
  jmp alltraps
80106d7b:	e9 4a fa ff ff       	jmp    801067ca <alltraps>

80106d80 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $15
80106d82:	6a 0f                	push   $0xf
  jmp alltraps
80106d84:	e9 41 fa ff ff       	jmp    801067ca <alltraps>

80106d89 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $16
80106d8b:	6a 10                	push   $0x10
  jmp alltraps
80106d8d:	e9 38 fa ff ff       	jmp    801067ca <alltraps>

80106d92 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d92:	6a 11                	push   $0x11
  jmp alltraps
80106d94:	e9 31 fa ff ff       	jmp    801067ca <alltraps>

80106d99 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d99:	6a 00                	push   $0x0
  pushl $18
80106d9b:	6a 12                	push   $0x12
  jmp alltraps
80106d9d:	e9 28 fa ff ff       	jmp    801067ca <alltraps>

80106da2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $19
80106da4:	6a 13                	push   $0x13
  jmp alltraps
80106da6:	e9 1f fa ff ff       	jmp    801067ca <alltraps>

80106dab <vector20>:
.globl vector20
vector20:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $20
80106dad:	6a 14                	push   $0x14
  jmp alltraps
80106daf:	e9 16 fa ff ff       	jmp    801067ca <alltraps>

80106db4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $21
80106db6:	6a 15                	push   $0x15
  jmp alltraps
80106db8:	e9 0d fa ff ff       	jmp    801067ca <alltraps>

80106dbd <vector22>:
.globl vector22
vector22:
  pushl $0
80106dbd:	6a 00                	push   $0x0
  pushl $22
80106dbf:	6a 16                	push   $0x16
  jmp alltraps
80106dc1:	e9 04 fa ff ff       	jmp    801067ca <alltraps>

80106dc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $23
80106dc8:	6a 17                	push   $0x17
  jmp alltraps
80106dca:	e9 fb f9 ff ff       	jmp    801067ca <alltraps>

80106dcf <vector24>:
.globl vector24
vector24:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $24
80106dd1:	6a 18                	push   $0x18
  jmp alltraps
80106dd3:	e9 f2 f9 ff ff       	jmp    801067ca <alltraps>

80106dd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106dd8:	6a 00                	push   $0x0
  pushl $25
80106dda:	6a 19                	push   $0x19
  jmp alltraps
80106ddc:	e9 e9 f9 ff ff       	jmp    801067ca <alltraps>

80106de1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106de1:	6a 00                	push   $0x0
  pushl $26
80106de3:	6a 1a                	push   $0x1a
  jmp alltraps
80106de5:	e9 e0 f9 ff ff       	jmp    801067ca <alltraps>

80106dea <vector27>:
.globl vector27
vector27:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $27
80106dec:	6a 1b                	push   $0x1b
  jmp alltraps
80106dee:	e9 d7 f9 ff ff       	jmp    801067ca <alltraps>

80106df3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $28
80106df5:	6a 1c                	push   $0x1c
  jmp alltraps
80106df7:	e9 ce f9 ff ff       	jmp    801067ca <alltraps>

80106dfc <vector29>:
.globl vector29
vector29:
  pushl $0
80106dfc:	6a 00                	push   $0x0
  pushl $29
80106dfe:	6a 1d                	push   $0x1d
  jmp alltraps
80106e00:	e9 c5 f9 ff ff       	jmp    801067ca <alltraps>

80106e05 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e05:	6a 00                	push   $0x0
  pushl $30
80106e07:	6a 1e                	push   $0x1e
  jmp alltraps
80106e09:	e9 bc f9 ff ff       	jmp    801067ca <alltraps>

80106e0e <vector31>:
.globl vector31
vector31:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $31
80106e10:	6a 1f                	push   $0x1f
  jmp alltraps
80106e12:	e9 b3 f9 ff ff       	jmp    801067ca <alltraps>

80106e17 <vector32>:
.globl vector32
vector32:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $32
80106e19:	6a 20                	push   $0x20
  jmp alltraps
80106e1b:	e9 aa f9 ff ff       	jmp    801067ca <alltraps>

80106e20 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e20:	6a 00                	push   $0x0
  pushl $33
80106e22:	6a 21                	push   $0x21
  jmp alltraps
80106e24:	e9 a1 f9 ff ff       	jmp    801067ca <alltraps>

80106e29 <vector34>:
.globl vector34
vector34:
  pushl $0
80106e29:	6a 00                	push   $0x0
  pushl $34
80106e2b:	6a 22                	push   $0x22
  jmp alltraps
80106e2d:	e9 98 f9 ff ff       	jmp    801067ca <alltraps>

80106e32 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $35
80106e34:	6a 23                	push   $0x23
  jmp alltraps
80106e36:	e9 8f f9 ff ff       	jmp    801067ca <alltraps>

80106e3b <vector36>:
.globl vector36
vector36:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $36
80106e3d:	6a 24                	push   $0x24
  jmp alltraps
80106e3f:	e9 86 f9 ff ff       	jmp    801067ca <alltraps>

80106e44 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e44:	6a 00                	push   $0x0
  pushl $37
80106e46:	6a 25                	push   $0x25
  jmp alltraps
80106e48:	e9 7d f9 ff ff       	jmp    801067ca <alltraps>

80106e4d <vector38>:
.globl vector38
vector38:
  pushl $0
80106e4d:	6a 00                	push   $0x0
  pushl $38
80106e4f:	6a 26                	push   $0x26
  jmp alltraps
80106e51:	e9 74 f9 ff ff       	jmp    801067ca <alltraps>

80106e56 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $39
80106e58:	6a 27                	push   $0x27
  jmp alltraps
80106e5a:	e9 6b f9 ff ff       	jmp    801067ca <alltraps>

80106e5f <vector40>:
.globl vector40
vector40:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $40
80106e61:	6a 28                	push   $0x28
  jmp alltraps
80106e63:	e9 62 f9 ff ff       	jmp    801067ca <alltraps>

80106e68 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e68:	6a 00                	push   $0x0
  pushl $41
80106e6a:	6a 29                	push   $0x29
  jmp alltraps
80106e6c:	e9 59 f9 ff ff       	jmp    801067ca <alltraps>

80106e71 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e71:	6a 00                	push   $0x0
  pushl $42
80106e73:	6a 2a                	push   $0x2a
  jmp alltraps
80106e75:	e9 50 f9 ff ff       	jmp    801067ca <alltraps>

80106e7a <vector43>:
.globl vector43
vector43:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $43
80106e7c:	6a 2b                	push   $0x2b
  jmp alltraps
80106e7e:	e9 47 f9 ff ff       	jmp    801067ca <alltraps>

80106e83 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $44
80106e85:	6a 2c                	push   $0x2c
  jmp alltraps
80106e87:	e9 3e f9 ff ff       	jmp    801067ca <alltraps>

80106e8c <vector45>:
.globl vector45
vector45:
  pushl $0
80106e8c:	6a 00                	push   $0x0
  pushl $45
80106e8e:	6a 2d                	push   $0x2d
  jmp alltraps
80106e90:	e9 35 f9 ff ff       	jmp    801067ca <alltraps>

80106e95 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e95:	6a 00                	push   $0x0
  pushl $46
80106e97:	6a 2e                	push   $0x2e
  jmp alltraps
80106e99:	e9 2c f9 ff ff       	jmp    801067ca <alltraps>

80106e9e <vector47>:
.globl vector47
vector47:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $47
80106ea0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ea2:	e9 23 f9 ff ff       	jmp    801067ca <alltraps>

80106ea7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $48
80106ea9:	6a 30                	push   $0x30
  jmp alltraps
80106eab:	e9 1a f9 ff ff       	jmp    801067ca <alltraps>

80106eb0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106eb0:	6a 00                	push   $0x0
  pushl $49
80106eb2:	6a 31                	push   $0x31
  jmp alltraps
80106eb4:	e9 11 f9 ff ff       	jmp    801067ca <alltraps>

80106eb9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106eb9:	6a 00                	push   $0x0
  pushl $50
80106ebb:	6a 32                	push   $0x32
  jmp alltraps
80106ebd:	e9 08 f9 ff ff       	jmp    801067ca <alltraps>

80106ec2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $51
80106ec4:	6a 33                	push   $0x33
  jmp alltraps
80106ec6:	e9 ff f8 ff ff       	jmp    801067ca <alltraps>

80106ecb <vector52>:
.globl vector52
vector52:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $52
80106ecd:	6a 34                	push   $0x34
  jmp alltraps
80106ecf:	e9 f6 f8 ff ff       	jmp    801067ca <alltraps>

80106ed4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ed4:	6a 00                	push   $0x0
  pushl $53
80106ed6:	6a 35                	push   $0x35
  jmp alltraps
80106ed8:	e9 ed f8 ff ff       	jmp    801067ca <alltraps>

80106edd <vector54>:
.globl vector54
vector54:
  pushl $0
80106edd:	6a 00                	push   $0x0
  pushl $54
80106edf:	6a 36                	push   $0x36
  jmp alltraps
80106ee1:	e9 e4 f8 ff ff       	jmp    801067ca <alltraps>

80106ee6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $55
80106ee8:	6a 37                	push   $0x37
  jmp alltraps
80106eea:	e9 db f8 ff ff       	jmp    801067ca <alltraps>

80106eef <vector56>:
.globl vector56
vector56:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $56
80106ef1:	6a 38                	push   $0x38
  jmp alltraps
80106ef3:	e9 d2 f8 ff ff       	jmp    801067ca <alltraps>

80106ef8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106ef8:	6a 00                	push   $0x0
  pushl $57
80106efa:	6a 39                	push   $0x39
  jmp alltraps
80106efc:	e9 c9 f8 ff ff       	jmp    801067ca <alltraps>

80106f01 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f01:	6a 00                	push   $0x0
  pushl $58
80106f03:	6a 3a                	push   $0x3a
  jmp alltraps
80106f05:	e9 c0 f8 ff ff       	jmp    801067ca <alltraps>

80106f0a <vector59>:
.globl vector59
vector59:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $59
80106f0c:	6a 3b                	push   $0x3b
  jmp alltraps
80106f0e:	e9 b7 f8 ff ff       	jmp    801067ca <alltraps>

80106f13 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $60
80106f15:	6a 3c                	push   $0x3c
  jmp alltraps
80106f17:	e9 ae f8 ff ff       	jmp    801067ca <alltraps>

80106f1c <vector61>:
.globl vector61
vector61:
  pushl $0
80106f1c:	6a 00                	push   $0x0
  pushl $61
80106f1e:	6a 3d                	push   $0x3d
  jmp alltraps
80106f20:	e9 a5 f8 ff ff       	jmp    801067ca <alltraps>

80106f25 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f25:	6a 00                	push   $0x0
  pushl $62
80106f27:	6a 3e                	push   $0x3e
  jmp alltraps
80106f29:	e9 9c f8 ff ff       	jmp    801067ca <alltraps>

80106f2e <vector63>:
.globl vector63
vector63:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $63
80106f30:	6a 3f                	push   $0x3f
  jmp alltraps
80106f32:	e9 93 f8 ff ff       	jmp    801067ca <alltraps>

80106f37 <vector64>:
.globl vector64
vector64:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $64
80106f39:	6a 40                	push   $0x40
  jmp alltraps
80106f3b:	e9 8a f8 ff ff       	jmp    801067ca <alltraps>

80106f40 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f40:	6a 00                	push   $0x0
  pushl $65
80106f42:	6a 41                	push   $0x41
  jmp alltraps
80106f44:	e9 81 f8 ff ff       	jmp    801067ca <alltraps>

80106f49 <vector66>:
.globl vector66
vector66:
  pushl $0
80106f49:	6a 00                	push   $0x0
  pushl $66
80106f4b:	6a 42                	push   $0x42
  jmp alltraps
80106f4d:	e9 78 f8 ff ff       	jmp    801067ca <alltraps>

80106f52 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $67
80106f54:	6a 43                	push   $0x43
  jmp alltraps
80106f56:	e9 6f f8 ff ff       	jmp    801067ca <alltraps>

80106f5b <vector68>:
.globl vector68
vector68:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $68
80106f5d:	6a 44                	push   $0x44
  jmp alltraps
80106f5f:	e9 66 f8 ff ff       	jmp    801067ca <alltraps>

80106f64 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f64:	6a 00                	push   $0x0
  pushl $69
80106f66:	6a 45                	push   $0x45
  jmp alltraps
80106f68:	e9 5d f8 ff ff       	jmp    801067ca <alltraps>

80106f6d <vector70>:
.globl vector70
vector70:
  pushl $0
80106f6d:	6a 00                	push   $0x0
  pushl $70
80106f6f:	6a 46                	push   $0x46
  jmp alltraps
80106f71:	e9 54 f8 ff ff       	jmp    801067ca <alltraps>

80106f76 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $71
80106f78:	6a 47                	push   $0x47
  jmp alltraps
80106f7a:	e9 4b f8 ff ff       	jmp    801067ca <alltraps>

80106f7f <vector72>:
.globl vector72
vector72:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $72
80106f81:	6a 48                	push   $0x48
  jmp alltraps
80106f83:	e9 42 f8 ff ff       	jmp    801067ca <alltraps>

80106f88 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f88:	6a 00                	push   $0x0
  pushl $73
80106f8a:	6a 49                	push   $0x49
  jmp alltraps
80106f8c:	e9 39 f8 ff ff       	jmp    801067ca <alltraps>

80106f91 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f91:	6a 00                	push   $0x0
  pushl $74
80106f93:	6a 4a                	push   $0x4a
  jmp alltraps
80106f95:	e9 30 f8 ff ff       	jmp    801067ca <alltraps>

80106f9a <vector75>:
.globl vector75
vector75:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $75
80106f9c:	6a 4b                	push   $0x4b
  jmp alltraps
80106f9e:	e9 27 f8 ff ff       	jmp    801067ca <alltraps>

80106fa3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $76
80106fa5:	6a 4c                	push   $0x4c
  jmp alltraps
80106fa7:	e9 1e f8 ff ff       	jmp    801067ca <alltraps>

80106fac <vector77>:
.globl vector77
vector77:
  pushl $0
80106fac:	6a 00                	push   $0x0
  pushl $77
80106fae:	6a 4d                	push   $0x4d
  jmp alltraps
80106fb0:	e9 15 f8 ff ff       	jmp    801067ca <alltraps>

80106fb5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106fb5:	6a 00                	push   $0x0
  pushl $78
80106fb7:	6a 4e                	push   $0x4e
  jmp alltraps
80106fb9:	e9 0c f8 ff ff       	jmp    801067ca <alltraps>

80106fbe <vector79>:
.globl vector79
vector79:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $79
80106fc0:	6a 4f                	push   $0x4f
  jmp alltraps
80106fc2:	e9 03 f8 ff ff       	jmp    801067ca <alltraps>

80106fc7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $80
80106fc9:	6a 50                	push   $0x50
  jmp alltraps
80106fcb:	e9 fa f7 ff ff       	jmp    801067ca <alltraps>

80106fd0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106fd0:	6a 00                	push   $0x0
  pushl $81
80106fd2:	6a 51                	push   $0x51
  jmp alltraps
80106fd4:	e9 f1 f7 ff ff       	jmp    801067ca <alltraps>

80106fd9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106fd9:	6a 00                	push   $0x0
  pushl $82
80106fdb:	6a 52                	push   $0x52
  jmp alltraps
80106fdd:	e9 e8 f7 ff ff       	jmp    801067ca <alltraps>

80106fe2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $83
80106fe4:	6a 53                	push   $0x53
  jmp alltraps
80106fe6:	e9 df f7 ff ff       	jmp    801067ca <alltraps>

80106feb <vector84>:
.globl vector84
vector84:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $84
80106fed:	6a 54                	push   $0x54
  jmp alltraps
80106fef:	e9 d6 f7 ff ff       	jmp    801067ca <alltraps>

80106ff4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ff4:	6a 00                	push   $0x0
  pushl $85
80106ff6:	6a 55                	push   $0x55
  jmp alltraps
80106ff8:	e9 cd f7 ff ff       	jmp    801067ca <alltraps>

80106ffd <vector86>:
.globl vector86
vector86:
  pushl $0
80106ffd:	6a 00                	push   $0x0
  pushl $86
80106fff:	6a 56                	push   $0x56
  jmp alltraps
80107001:	e9 c4 f7 ff ff       	jmp    801067ca <alltraps>

80107006 <vector87>:
.globl vector87
vector87:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $87
80107008:	6a 57                	push   $0x57
  jmp alltraps
8010700a:	e9 bb f7 ff ff       	jmp    801067ca <alltraps>

8010700f <vector88>:
.globl vector88
vector88:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $88
80107011:	6a 58                	push   $0x58
  jmp alltraps
80107013:	e9 b2 f7 ff ff       	jmp    801067ca <alltraps>

80107018 <vector89>:
.globl vector89
vector89:
  pushl $0
80107018:	6a 00                	push   $0x0
  pushl $89
8010701a:	6a 59                	push   $0x59
  jmp alltraps
8010701c:	e9 a9 f7 ff ff       	jmp    801067ca <alltraps>

80107021 <vector90>:
.globl vector90
vector90:
  pushl $0
80107021:	6a 00                	push   $0x0
  pushl $90
80107023:	6a 5a                	push   $0x5a
  jmp alltraps
80107025:	e9 a0 f7 ff ff       	jmp    801067ca <alltraps>

8010702a <vector91>:
.globl vector91
vector91:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $91
8010702c:	6a 5b                	push   $0x5b
  jmp alltraps
8010702e:	e9 97 f7 ff ff       	jmp    801067ca <alltraps>

80107033 <vector92>:
.globl vector92
vector92:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $92
80107035:	6a 5c                	push   $0x5c
  jmp alltraps
80107037:	e9 8e f7 ff ff       	jmp    801067ca <alltraps>

8010703c <vector93>:
.globl vector93
vector93:
  pushl $0
8010703c:	6a 00                	push   $0x0
  pushl $93
8010703e:	6a 5d                	push   $0x5d
  jmp alltraps
80107040:	e9 85 f7 ff ff       	jmp    801067ca <alltraps>

80107045 <vector94>:
.globl vector94
vector94:
  pushl $0
80107045:	6a 00                	push   $0x0
  pushl $94
80107047:	6a 5e                	push   $0x5e
  jmp alltraps
80107049:	e9 7c f7 ff ff       	jmp    801067ca <alltraps>

8010704e <vector95>:
.globl vector95
vector95:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $95
80107050:	6a 5f                	push   $0x5f
  jmp alltraps
80107052:	e9 73 f7 ff ff       	jmp    801067ca <alltraps>

80107057 <vector96>:
.globl vector96
vector96:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $96
80107059:	6a 60                	push   $0x60
  jmp alltraps
8010705b:	e9 6a f7 ff ff       	jmp    801067ca <alltraps>

80107060 <vector97>:
.globl vector97
vector97:
  pushl $0
80107060:	6a 00                	push   $0x0
  pushl $97
80107062:	6a 61                	push   $0x61
  jmp alltraps
80107064:	e9 61 f7 ff ff       	jmp    801067ca <alltraps>

80107069 <vector98>:
.globl vector98
vector98:
  pushl $0
80107069:	6a 00                	push   $0x0
  pushl $98
8010706b:	6a 62                	push   $0x62
  jmp alltraps
8010706d:	e9 58 f7 ff ff       	jmp    801067ca <alltraps>

80107072 <vector99>:
.globl vector99
vector99:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $99
80107074:	6a 63                	push   $0x63
  jmp alltraps
80107076:	e9 4f f7 ff ff       	jmp    801067ca <alltraps>

8010707b <vector100>:
.globl vector100
vector100:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $100
8010707d:	6a 64                	push   $0x64
  jmp alltraps
8010707f:	e9 46 f7 ff ff       	jmp    801067ca <alltraps>

80107084 <vector101>:
.globl vector101
vector101:
  pushl $0
80107084:	6a 00                	push   $0x0
  pushl $101
80107086:	6a 65                	push   $0x65
  jmp alltraps
80107088:	e9 3d f7 ff ff       	jmp    801067ca <alltraps>

8010708d <vector102>:
.globl vector102
vector102:
  pushl $0
8010708d:	6a 00                	push   $0x0
  pushl $102
8010708f:	6a 66                	push   $0x66
  jmp alltraps
80107091:	e9 34 f7 ff ff       	jmp    801067ca <alltraps>

80107096 <vector103>:
.globl vector103
vector103:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $103
80107098:	6a 67                	push   $0x67
  jmp alltraps
8010709a:	e9 2b f7 ff ff       	jmp    801067ca <alltraps>

8010709f <vector104>:
.globl vector104
vector104:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $104
801070a1:	6a 68                	push   $0x68
  jmp alltraps
801070a3:	e9 22 f7 ff ff       	jmp    801067ca <alltraps>

801070a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801070a8:	6a 00                	push   $0x0
  pushl $105
801070aa:	6a 69                	push   $0x69
  jmp alltraps
801070ac:	e9 19 f7 ff ff       	jmp    801067ca <alltraps>

801070b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801070b1:	6a 00                	push   $0x0
  pushl $106
801070b3:	6a 6a                	push   $0x6a
  jmp alltraps
801070b5:	e9 10 f7 ff ff       	jmp    801067ca <alltraps>

801070ba <vector107>:
.globl vector107
vector107:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $107
801070bc:	6a 6b                	push   $0x6b
  jmp alltraps
801070be:	e9 07 f7 ff ff       	jmp    801067ca <alltraps>

801070c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $108
801070c5:	6a 6c                	push   $0x6c
  jmp alltraps
801070c7:	e9 fe f6 ff ff       	jmp    801067ca <alltraps>

801070cc <vector109>:
.globl vector109
vector109:
  pushl $0
801070cc:	6a 00                	push   $0x0
  pushl $109
801070ce:	6a 6d                	push   $0x6d
  jmp alltraps
801070d0:	e9 f5 f6 ff ff       	jmp    801067ca <alltraps>

801070d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801070d5:	6a 00                	push   $0x0
  pushl $110
801070d7:	6a 6e                	push   $0x6e
  jmp alltraps
801070d9:	e9 ec f6 ff ff       	jmp    801067ca <alltraps>

801070de <vector111>:
.globl vector111
vector111:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $111
801070e0:	6a 6f                	push   $0x6f
  jmp alltraps
801070e2:	e9 e3 f6 ff ff       	jmp    801067ca <alltraps>

801070e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $112
801070e9:	6a 70                	push   $0x70
  jmp alltraps
801070eb:	e9 da f6 ff ff       	jmp    801067ca <alltraps>

801070f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $113
801070f2:	6a 71                	push   $0x71
  jmp alltraps
801070f4:	e9 d1 f6 ff ff       	jmp    801067ca <alltraps>

801070f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801070f9:	6a 00                	push   $0x0
  pushl $114
801070fb:	6a 72                	push   $0x72
  jmp alltraps
801070fd:	e9 c8 f6 ff ff       	jmp    801067ca <alltraps>

80107102 <vector115>:
.globl vector115
vector115:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $115
80107104:	6a 73                	push   $0x73
  jmp alltraps
80107106:	e9 bf f6 ff ff       	jmp    801067ca <alltraps>

8010710b <vector116>:
.globl vector116
vector116:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $116
8010710d:	6a 74                	push   $0x74
  jmp alltraps
8010710f:	e9 b6 f6 ff ff       	jmp    801067ca <alltraps>

80107114 <vector117>:
.globl vector117
vector117:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $117
80107116:	6a 75                	push   $0x75
  jmp alltraps
80107118:	e9 ad f6 ff ff       	jmp    801067ca <alltraps>

8010711d <vector118>:
.globl vector118
vector118:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $118
8010711f:	6a 76                	push   $0x76
  jmp alltraps
80107121:	e9 a4 f6 ff ff       	jmp    801067ca <alltraps>

80107126 <vector119>:
.globl vector119
vector119:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $119
80107128:	6a 77                	push   $0x77
  jmp alltraps
8010712a:	e9 9b f6 ff ff       	jmp    801067ca <alltraps>

8010712f <vector120>:
.globl vector120
vector120:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $120
80107131:	6a 78                	push   $0x78
  jmp alltraps
80107133:	e9 92 f6 ff ff       	jmp    801067ca <alltraps>

80107138 <vector121>:
.globl vector121
vector121:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $121
8010713a:	6a 79                	push   $0x79
  jmp alltraps
8010713c:	e9 89 f6 ff ff       	jmp    801067ca <alltraps>

80107141 <vector122>:
.globl vector122
vector122:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $122
80107143:	6a 7a                	push   $0x7a
  jmp alltraps
80107145:	e9 80 f6 ff ff       	jmp    801067ca <alltraps>

8010714a <vector123>:
.globl vector123
vector123:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $123
8010714c:	6a 7b                	push   $0x7b
  jmp alltraps
8010714e:	e9 77 f6 ff ff       	jmp    801067ca <alltraps>

80107153 <vector124>:
.globl vector124
vector124:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $124
80107155:	6a 7c                	push   $0x7c
  jmp alltraps
80107157:	e9 6e f6 ff ff       	jmp    801067ca <alltraps>

8010715c <vector125>:
.globl vector125
vector125:
  pushl $0
8010715c:	6a 00                	push   $0x0
  pushl $125
8010715e:	6a 7d                	push   $0x7d
  jmp alltraps
80107160:	e9 65 f6 ff ff       	jmp    801067ca <alltraps>

80107165 <vector126>:
.globl vector126
vector126:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $126
80107167:	6a 7e                	push   $0x7e
  jmp alltraps
80107169:	e9 5c f6 ff ff       	jmp    801067ca <alltraps>

8010716e <vector127>:
.globl vector127
vector127:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $127
80107170:	6a 7f                	push   $0x7f
  jmp alltraps
80107172:	e9 53 f6 ff ff       	jmp    801067ca <alltraps>

80107177 <vector128>:
.globl vector128
vector128:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $128
80107179:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010717e:	e9 47 f6 ff ff       	jmp    801067ca <alltraps>

80107183 <vector129>:
.globl vector129
vector129:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $129
80107185:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010718a:	e9 3b f6 ff ff       	jmp    801067ca <alltraps>

8010718f <vector130>:
.globl vector130
vector130:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $130
80107191:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107196:	e9 2f f6 ff ff       	jmp    801067ca <alltraps>

8010719b <vector131>:
.globl vector131
vector131:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $131
8010719d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071a2:	e9 23 f6 ff ff       	jmp    801067ca <alltraps>

801071a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $132
801071a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071ae:	e9 17 f6 ff ff       	jmp    801067ca <alltraps>

801071b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $133
801071b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071ba:	e9 0b f6 ff ff       	jmp    801067ca <alltraps>

801071bf <vector134>:
.globl vector134
vector134:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $134
801071c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071c6:	e9 ff f5 ff ff       	jmp    801067ca <alltraps>

801071cb <vector135>:
.globl vector135
vector135:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $135
801071cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801071d2:	e9 f3 f5 ff ff       	jmp    801067ca <alltraps>

801071d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $136
801071d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801071de:	e9 e7 f5 ff ff       	jmp    801067ca <alltraps>

801071e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $137
801071e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801071ea:	e9 db f5 ff ff       	jmp    801067ca <alltraps>

801071ef <vector138>:
.globl vector138
vector138:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $138
801071f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801071f6:	e9 cf f5 ff ff       	jmp    801067ca <alltraps>

801071fb <vector139>:
.globl vector139
vector139:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $139
801071fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107202:	e9 c3 f5 ff ff       	jmp    801067ca <alltraps>

80107207 <vector140>:
.globl vector140
vector140:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $140
80107209:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010720e:	e9 b7 f5 ff ff       	jmp    801067ca <alltraps>

80107213 <vector141>:
.globl vector141
vector141:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $141
80107215:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010721a:	e9 ab f5 ff ff       	jmp    801067ca <alltraps>

8010721f <vector142>:
.globl vector142
vector142:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $142
80107221:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107226:	e9 9f f5 ff ff       	jmp    801067ca <alltraps>

8010722b <vector143>:
.globl vector143
vector143:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $143
8010722d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107232:	e9 93 f5 ff ff       	jmp    801067ca <alltraps>

80107237 <vector144>:
.globl vector144
vector144:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $144
80107239:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010723e:	e9 87 f5 ff ff       	jmp    801067ca <alltraps>

80107243 <vector145>:
.globl vector145
vector145:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $145
80107245:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010724a:	e9 7b f5 ff ff       	jmp    801067ca <alltraps>

8010724f <vector146>:
.globl vector146
vector146:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $146
80107251:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107256:	e9 6f f5 ff ff       	jmp    801067ca <alltraps>

8010725b <vector147>:
.globl vector147
vector147:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $147
8010725d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107262:	e9 63 f5 ff ff       	jmp    801067ca <alltraps>

80107267 <vector148>:
.globl vector148
vector148:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $148
80107269:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010726e:	e9 57 f5 ff ff       	jmp    801067ca <alltraps>

80107273 <vector149>:
.globl vector149
vector149:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $149
80107275:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010727a:	e9 4b f5 ff ff       	jmp    801067ca <alltraps>

8010727f <vector150>:
.globl vector150
vector150:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $150
80107281:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107286:	e9 3f f5 ff ff       	jmp    801067ca <alltraps>

8010728b <vector151>:
.globl vector151
vector151:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $151
8010728d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107292:	e9 33 f5 ff ff       	jmp    801067ca <alltraps>

80107297 <vector152>:
.globl vector152
vector152:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $152
80107299:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010729e:	e9 27 f5 ff ff       	jmp    801067ca <alltraps>

801072a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $153
801072a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072aa:	e9 1b f5 ff ff       	jmp    801067ca <alltraps>

801072af <vector154>:
.globl vector154
vector154:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $154
801072b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072b6:	e9 0f f5 ff ff       	jmp    801067ca <alltraps>

801072bb <vector155>:
.globl vector155
vector155:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $155
801072bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072c2:	e9 03 f5 ff ff       	jmp    801067ca <alltraps>

801072c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $156
801072c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801072ce:	e9 f7 f4 ff ff       	jmp    801067ca <alltraps>

801072d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $157
801072d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801072da:	e9 eb f4 ff ff       	jmp    801067ca <alltraps>

801072df <vector158>:
.globl vector158
vector158:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $158
801072e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801072e6:	e9 df f4 ff ff       	jmp    801067ca <alltraps>

801072eb <vector159>:
.globl vector159
vector159:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $159
801072ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072f2:	e9 d3 f4 ff ff       	jmp    801067ca <alltraps>

801072f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $160
801072f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072fe:	e9 c7 f4 ff ff       	jmp    801067ca <alltraps>

80107303 <vector161>:
.globl vector161
vector161:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $161
80107305:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010730a:	e9 bb f4 ff ff       	jmp    801067ca <alltraps>

8010730f <vector162>:
.globl vector162
vector162:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $162
80107311:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107316:	e9 af f4 ff ff       	jmp    801067ca <alltraps>

8010731b <vector163>:
.globl vector163
vector163:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $163
8010731d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107322:	e9 a3 f4 ff ff       	jmp    801067ca <alltraps>

80107327 <vector164>:
.globl vector164
vector164:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $164
80107329:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010732e:	e9 97 f4 ff ff       	jmp    801067ca <alltraps>

80107333 <vector165>:
.globl vector165
vector165:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $165
80107335:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010733a:	e9 8b f4 ff ff       	jmp    801067ca <alltraps>

8010733f <vector166>:
.globl vector166
vector166:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $166
80107341:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107346:	e9 7f f4 ff ff       	jmp    801067ca <alltraps>

8010734b <vector167>:
.globl vector167
vector167:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $167
8010734d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107352:	e9 73 f4 ff ff       	jmp    801067ca <alltraps>

80107357 <vector168>:
.globl vector168
vector168:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $168
80107359:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010735e:	e9 67 f4 ff ff       	jmp    801067ca <alltraps>

80107363 <vector169>:
.globl vector169
vector169:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $169
80107365:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010736a:	e9 5b f4 ff ff       	jmp    801067ca <alltraps>

8010736f <vector170>:
.globl vector170
vector170:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $170
80107371:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107376:	e9 4f f4 ff ff       	jmp    801067ca <alltraps>

8010737b <vector171>:
.globl vector171
vector171:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $171
8010737d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107382:	e9 43 f4 ff ff       	jmp    801067ca <alltraps>

80107387 <vector172>:
.globl vector172
vector172:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $172
80107389:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010738e:	e9 37 f4 ff ff       	jmp    801067ca <alltraps>

80107393 <vector173>:
.globl vector173
vector173:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $173
80107395:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010739a:	e9 2b f4 ff ff       	jmp    801067ca <alltraps>

8010739f <vector174>:
.globl vector174
vector174:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $174
801073a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073a6:	e9 1f f4 ff ff       	jmp    801067ca <alltraps>

801073ab <vector175>:
.globl vector175
vector175:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $175
801073ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073b2:	e9 13 f4 ff ff       	jmp    801067ca <alltraps>

801073b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $176
801073b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073be:	e9 07 f4 ff ff       	jmp    801067ca <alltraps>

801073c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $177
801073c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073ca:	e9 fb f3 ff ff       	jmp    801067ca <alltraps>

801073cf <vector178>:
.globl vector178
vector178:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $178
801073d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801073d6:	e9 ef f3 ff ff       	jmp    801067ca <alltraps>

801073db <vector179>:
.globl vector179
vector179:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $179
801073dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801073e2:	e9 e3 f3 ff ff       	jmp    801067ca <alltraps>

801073e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $180
801073e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073ee:	e9 d7 f3 ff ff       	jmp    801067ca <alltraps>

801073f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $181
801073f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801073fa:	e9 cb f3 ff ff       	jmp    801067ca <alltraps>

801073ff <vector182>:
.globl vector182
vector182:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $182
80107401:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107406:	e9 bf f3 ff ff       	jmp    801067ca <alltraps>

8010740b <vector183>:
.globl vector183
vector183:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $183
8010740d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107412:	e9 b3 f3 ff ff       	jmp    801067ca <alltraps>

80107417 <vector184>:
.globl vector184
vector184:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $184
80107419:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010741e:	e9 a7 f3 ff ff       	jmp    801067ca <alltraps>

80107423 <vector185>:
.globl vector185
vector185:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $185
80107425:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010742a:	e9 9b f3 ff ff       	jmp    801067ca <alltraps>

8010742f <vector186>:
.globl vector186
vector186:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $186
80107431:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107436:	e9 8f f3 ff ff       	jmp    801067ca <alltraps>

8010743b <vector187>:
.globl vector187
vector187:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $187
8010743d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107442:	e9 83 f3 ff ff       	jmp    801067ca <alltraps>

80107447 <vector188>:
.globl vector188
vector188:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $188
80107449:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010744e:	e9 77 f3 ff ff       	jmp    801067ca <alltraps>

80107453 <vector189>:
.globl vector189
vector189:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $189
80107455:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010745a:	e9 6b f3 ff ff       	jmp    801067ca <alltraps>

8010745f <vector190>:
.globl vector190
vector190:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $190
80107461:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107466:	e9 5f f3 ff ff       	jmp    801067ca <alltraps>

8010746b <vector191>:
.globl vector191
vector191:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $191
8010746d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107472:	e9 53 f3 ff ff       	jmp    801067ca <alltraps>

80107477 <vector192>:
.globl vector192
vector192:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $192
80107479:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010747e:	e9 47 f3 ff ff       	jmp    801067ca <alltraps>

80107483 <vector193>:
.globl vector193
vector193:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $193
80107485:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010748a:	e9 3b f3 ff ff       	jmp    801067ca <alltraps>

8010748f <vector194>:
.globl vector194
vector194:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $194
80107491:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107496:	e9 2f f3 ff ff       	jmp    801067ca <alltraps>

8010749b <vector195>:
.globl vector195
vector195:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $195
8010749d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074a2:	e9 23 f3 ff ff       	jmp    801067ca <alltraps>

801074a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $196
801074a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074ae:	e9 17 f3 ff ff       	jmp    801067ca <alltraps>

801074b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $197
801074b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074ba:	e9 0b f3 ff ff       	jmp    801067ca <alltraps>

801074bf <vector198>:
.globl vector198
vector198:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $198
801074c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074c6:	e9 ff f2 ff ff       	jmp    801067ca <alltraps>

801074cb <vector199>:
.globl vector199
vector199:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $199
801074cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801074d2:	e9 f3 f2 ff ff       	jmp    801067ca <alltraps>

801074d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $200
801074d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801074de:	e9 e7 f2 ff ff       	jmp    801067ca <alltraps>

801074e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $201
801074e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801074ea:	e9 db f2 ff ff       	jmp    801067ca <alltraps>

801074ef <vector202>:
.globl vector202
vector202:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $202
801074f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801074f6:	e9 cf f2 ff ff       	jmp    801067ca <alltraps>

801074fb <vector203>:
.globl vector203
vector203:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $203
801074fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107502:	e9 c3 f2 ff ff       	jmp    801067ca <alltraps>

80107507 <vector204>:
.globl vector204
vector204:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $204
80107509:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010750e:	e9 b7 f2 ff ff       	jmp    801067ca <alltraps>

80107513 <vector205>:
.globl vector205
vector205:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $205
80107515:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010751a:	e9 ab f2 ff ff       	jmp    801067ca <alltraps>

8010751f <vector206>:
.globl vector206
vector206:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $206
80107521:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107526:	e9 9f f2 ff ff       	jmp    801067ca <alltraps>

8010752b <vector207>:
.globl vector207
vector207:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $207
8010752d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107532:	e9 93 f2 ff ff       	jmp    801067ca <alltraps>

80107537 <vector208>:
.globl vector208
vector208:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $208
80107539:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010753e:	e9 87 f2 ff ff       	jmp    801067ca <alltraps>

80107543 <vector209>:
.globl vector209
vector209:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $209
80107545:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010754a:	e9 7b f2 ff ff       	jmp    801067ca <alltraps>

8010754f <vector210>:
.globl vector210
vector210:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $210
80107551:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107556:	e9 6f f2 ff ff       	jmp    801067ca <alltraps>

8010755b <vector211>:
.globl vector211
vector211:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $211
8010755d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107562:	e9 63 f2 ff ff       	jmp    801067ca <alltraps>

80107567 <vector212>:
.globl vector212
vector212:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $212
80107569:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010756e:	e9 57 f2 ff ff       	jmp    801067ca <alltraps>

80107573 <vector213>:
.globl vector213
vector213:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $213
80107575:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010757a:	e9 4b f2 ff ff       	jmp    801067ca <alltraps>

8010757f <vector214>:
.globl vector214
vector214:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $214
80107581:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107586:	e9 3f f2 ff ff       	jmp    801067ca <alltraps>

8010758b <vector215>:
.globl vector215
vector215:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $215
8010758d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107592:	e9 33 f2 ff ff       	jmp    801067ca <alltraps>

80107597 <vector216>:
.globl vector216
vector216:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $216
80107599:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010759e:	e9 27 f2 ff ff       	jmp    801067ca <alltraps>

801075a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $217
801075a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075aa:	e9 1b f2 ff ff       	jmp    801067ca <alltraps>

801075af <vector218>:
.globl vector218
vector218:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $218
801075b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075b6:	e9 0f f2 ff ff       	jmp    801067ca <alltraps>

801075bb <vector219>:
.globl vector219
vector219:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $219
801075bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075c2:	e9 03 f2 ff ff       	jmp    801067ca <alltraps>

801075c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $220
801075c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801075ce:	e9 f7 f1 ff ff       	jmp    801067ca <alltraps>

801075d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $221
801075d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801075da:	e9 eb f1 ff ff       	jmp    801067ca <alltraps>

801075df <vector222>:
.globl vector222
vector222:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $222
801075e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801075e6:	e9 df f1 ff ff       	jmp    801067ca <alltraps>

801075eb <vector223>:
.globl vector223
vector223:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $223
801075ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075f2:	e9 d3 f1 ff ff       	jmp    801067ca <alltraps>

801075f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $224
801075f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075fe:	e9 c7 f1 ff ff       	jmp    801067ca <alltraps>

80107603 <vector225>:
.globl vector225
vector225:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $225
80107605:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010760a:	e9 bb f1 ff ff       	jmp    801067ca <alltraps>

8010760f <vector226>:
.globl vector226
vector226:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $226
80107611:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107616:	e9 af f1 ff ff       	jmp    801067ca <alltraps>

8010761b <vector227>:
.globl vector227
vector227:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $227
8010761d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107622:	e9 a3 f1 ff ff       	jmp    801067ca <alltraps>

80107627 <vector228>:
.globl vector228
vector228:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $228
80107629:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010762e:	e9 97 f1 ff ff       	jmp    801067ca <alltraps>

80107633 <vector229>:
.globl vector229
vector229:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $229
80107635:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010763a:	e9 8b f1 ff ff       	jmp    801067ca <alltraps>

8010763f <vector230>:
.globl vector230
vector230:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $230
80107641:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107646:	e9 7f f1 ff ff       	jmp    801067ca <alltraps>

8010764b <vector231>:
.globl vector231
vector231:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $231
8010764d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107652:	e9 73 f1 ff ff       	jmp    801067ca <alltraps>

80107657 <vector232>:
.globl vector232
vector232:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $232
80107659:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010765e:	e9 67 f1 ff ff       	jmp    801067ca <alltraps>

80107663 <vector233>:
.globl vector233
vector233:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $233
80107665:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010766a:	e9 5b f1 ff ff       	jmp    801067ca <alltraps>

8010766f <vector234>:
.globl vector234
vector234:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $234
80107671:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107676:	e9 4f f1 ff ff       	jmp    801067ca <alltraps>

8010767b <vector235>:
.globl vector235
vector235:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $235
8010767d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107682:	e9 43 f1 ff ff       	jmp    801067ca <alltraps>

80107687 <vector236>:
.globl vector236
vector236:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $236
80107689:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010768e:	e9 37 f1 ff ff       	jmp    801067ca <alltraps>

80107693 <vector237>:
.globl vector237
vector237:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $237
80107695:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010769a:	e9 2b f1 ff ff       	jmp    801067ca <alltraps>

8010769f <vector238>:
.globl vector238
vector238:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $238
801076a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076a6:	e9 1f f1 ff ff       	jmp    801067ca <alltraps>

801076ab <vector239>:
.globl vector239
vector239:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $239
801076ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076b2:	e9 13 f1 ff ff       	jmp    801067ca <alltraps>

801076b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $240
801076b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076be:	e9 07 f1 ff ff       	jmp    801067ca <alltraps>

801076c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $241
801076c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076ca:	e9 fb f0 ff ff       	jmp    801067ca <alltraps>

801076cf <vector242>:
.globl vector242
vector242:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $242
801076d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801076d6:	e9 ef f0 ff ff       	jmp    801067ca <alltraps>

801076db <vector243>:
.globl vector243
vector243:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $243
801076dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801076e2:	e9 e3 f0 ff ff       	jmp    801067ca <alltraps>

801076e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $244
801076e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076ee:	e9 d7 f0 ff ff       	jmp    801067ca <alltraps>

801076f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $245
801076f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801076fa:	e9 cb f0 ff ff       	jmp    801067ca <alltraps>

801076ff <vector246>:
.globl vector246
vector246:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $246
80107701:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107706:	e9 bf f0 ff ff       	jmp    801067ca <alltraps>

8010770b <vector247>:
.globl vector247
vector247:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $247
8010770d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107712:	e9 b3 f0 ff ff       	jmp    801067ca <alltraps>

80107717 <vector248>:
.globl vector248
vector248:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $248
80107719:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010771e:	e9 a7 f0 ff ff       	jmp    801067ca <alltraps>

80107723 <vector249>:
.globl vector249
vector249:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $249
80107725:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010772a:	e9 9b f0 ff ff       	jmp    801067ca <alltraps>

8010772f <vector250>:
.globl vector250
vector250:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $250
80107731:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107736:	e9 8f f0 ff ff       	jmp    801067ca <alltraps>

8010773b <vector251>:
.globl vector251
vector251:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $251
8010773d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107742:	e9 83 f0 ff ff       	jmp    801067ca <alltraps>

80107747 <vector252>:
.globl vector252
vector252:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $252
80107749:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010774e:	e9 77 f0 ff ff       	jmp    801067ca <alltraps>

80107753 <vector253>:
.globl vector253
vector253:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $253
80107755:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010775a:	e9 6b f0 ff ff       	jmp    801067ca <alltraps>

8010775f <vector254>:
.globl vector254
vector254:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $254
80107761:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107766:	e9 5f f0 ff ff       	jmp    801067ca <alltraps>

8010776b <vector255>:
.globl vector255
vector255:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $255
8010776d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107772:	e9 53 f0 ff ff       	jmp    801067ca <alltraps>
80107777:	66 90                	xchg   %ax,%ax
80107779:	66 90                	xchg   %ax,%ax
8010777b:	66 90                	xchg   %ax,%ax
8010777d:	66 90                	xchg   %ax,%ax
8010777f:	90                   	nop

80107780 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107786:	89 d3                	mov    %edx,%ebx
{
80107788:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010778a:	c1 eb 16             	shr    $0x16,%ebx
8010778d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107790:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107793:	8b 06                	mov    (%esi),%eax
80107795:	a8 01                	test   $0x1,%al
80107797:	74 27                	je     801077c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107799:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010779e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801077a4:	c1 ef 0a             	shr    $0xa,%edi
}
801077a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801077aa:	89 fa                	mov    %edi,%edx
801077ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801077b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801077b5:	5b                   	pop    %ebx
801077b6:	5e                   	pop    %esi
801077b7:	5f                   	pop    %edi
801077b8:	5d                   	pop    %ebp
801077b9:	c3                   	ret    
801077ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801077c0:	85 c9                	test   %ecx,%ecx
801077c2:	74 2c                	je     801077f0 <walkpgdir+0x70>
801077c4:	e8 f7 ac ff ff       	call   801024c0 <kalloc>
801077c9:	85 c0                	test   %eax,%eax
801077cb:	89 c3                	mov    %eax,%ebx
801077cd:	74 21                	je     801077f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801077cf:	83 ec 04             	sub    $0x4,%esp
801077d2:	68 00 10 00 00       	push   $0x1000
801077d7:	6a 00                	push   $0x0
801077d9:	50                   	push   %eax
801077da:	e8 11 dd ff ff       	call   801054f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077e5:	83 c4 10             	add    $0x10,%esp
801077e8:	83 c8 07             	or     $0x7,%eax
801077eb:	89 06                	mov    %eax,(%esi)
801077ed:	eb b5                	jmp    801077a4 <walkpgdir+0x24>
801077ef:	90                   	nop
}
801077f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801077f3:	31 c0                	xor    %eax,%eax
}
801077f5:	5b                   	pop    %ebx
801077f6:	5e                   	pop    %esi
801077f7:	5f                   	pop    %edi
801077f8:	5d                   	pop    %ebp
801077f9:	c3                   	ret    
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107800 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107806:	89 d3                	mov    %edx,%ebx
80107808:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010780e:	83 ec 1c             	sub    $0x1c,%esp
80107811:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107814:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107818:	8b 7d 08             	mov    0x8(%ebp),%edi
8010781b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107820:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107823:	8b 45 0c             	mov    0xc(%ebp),%eax
80107826:	29 df                	sub    %ebx,%edi
80107828:	83 c8 01             	or     $0x1,%eax
8010782b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010782e:	eb 15                	jmp    80107845 <mappages+0x45>
    if(*pte & PTE_P)
80107830:	f6 00 01             	testb  $0x1,(%eax)
80107833:	75 45                	jne    8010787a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107835:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107838:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010783b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010783d:	74 31                	je     80107870 <mappages+0x70>
      break;
    a += PGSIZE;
8010783f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107848:	b9 01 00 00 00       	mov    $0x1,%ecx
8010784d:	89 da                	mov    %ebx,%edx
8010784f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107852:	e8 29 ff ff ff       	call   80107780 <walkpgdir>
80107857:	85 c0                	test   %eax,%eax
80107859:	75 d5                	jne    80107830 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010785b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010785e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107863:	5b                   	pop    %ebx
80107864:	5e                   	pop    %esi
80107865:	5f                   	pop    %edi
80107866:	5d                   	pop    %ebp
80107867:	c3                   	ret    
80107868:	90                   	nop
80107869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107873:	31 c0                	xor    %eax,%eax
}
80107875:	5b                   	pop    %ebx
80107876:	5e                   	pop    %esi
80107877:	5f                   	pop    %edi
80107878:	5d                   	pop    %ebp
80107879:	c3                   	ret    
      panic("remap");
8010787a:	83 ec 0c             	sub    $0xc,%esp
8010787d:	68 b8 8a 10 80       	push   $0x80108ab8
80107882:	e8 09 8b ff ff       	call   80100390 <panic>
80107887:	89 f6                	mov    %esi,%esi
80107889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107890 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107896:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010789c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010789e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078a4:	83 ec 1c             	sub    $0x1c,%esp
801078a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801078aa:	39 d3                	cmp    %edx,%ebx
801078ac:	73 66                	jae    80107914 <deallocuvm.part.0+0x84>
801078ae:	89 d6                	mov    %edx,%esi
801078b0:	eb 3d                	jmp    801078ef <deallocuvm.part.0+0x5f>
801078b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801078b8:	8b 10                	mov    (%eax),%edx
801078ba:	f6 c2 01             	test   $0x1,%dl
801078bd:	74 26                	je     801078e5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801078bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801078c5:	74 58                	je     8010791f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801078c7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801078ca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801078d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801078d3:	52                   	push   %edx
801078d4:	e8 37 aa ff ff       	call   80102310 <kfree>
      *pte = 0;
801078d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078dc:	83 c4 10             	add    $0x10,%esp
801078df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801078e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078eb:	39 f3                	cmp    %esi,%ebx
801078ed:	73 25                	jae    80107914 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801078ef:	31 c9                	xor    %ecx,%ecx
801078f1:	89 da                	mov    %ebx,%edx
801078f3:	89 f8                	mov    %edi,%eax
801078f5:	e8 86 fe ff ff       	call   80107780 <walkpgdir>
    if(!pte)
801078fa:	85 c0                	test   %eax,%eax
801078fc:	75 ba                	jne    801078b8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801078fe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107904:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010790a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107910:	39 f3                	cmp    %esi,%ebx
80107912:	72 db                	jb     801078ef <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107914:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107917:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010791a:	5b                   	pop    %ebx
8010791b:	5e                   	pop    %esi
8010791c:	5f                   	pop    %edi
8010791d:	5d                   	pop    %ebp
8010791e:	c3                   	ret    
        panic("kfree");
8010791f:	83 ec 0c             	sub    $0xc,%esp
80107922:	68 26 83 10 80       	push   $0x80108326
80107927:	e8 64 8a ff ff       	call   80100390 <panic>
8010792c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107930 <seginit>:
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107936:	e8 05 bf ff ff       	call   80103840 <cpuid>
8010793b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107941:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107946:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010794a:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80107951:	ff 00 00 
80107954:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
8010795b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010795e:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80107965:	ff 00 00 
80107968:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
8010796f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107972:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
80107979:	ff 00 00 
8010797c:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80107983:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107986:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
8010798d:	ff 00 00 
80107990:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
80107997:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010799a:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
8010799f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801079a3:	c1 e8 10             	shr    $0x10,%eax
801079a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801079aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801079ad:	0f 01 10             	lgdtl  (%eax)
}
801079b0:	c9                   	leave  
801079b1:	c3                   	ret    
801079b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079c0:	a1 c4 72 11 80       	mov    0x801172c4,%eax
{
801079c5:	55                   	push   %ebp
801079c6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079cd:	0f 22 d8             	mov    %eax,%cr3
}
801079d0:	5d                   	pop    %ebp
801079d1:	c3                   	ret    
801079d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079e0 <switchuvm>:
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 1c             	sub    $0x1c,%esp
801079e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801079ec:	85 db                	test   %ebx,%ebx
801079ee:	0f 84 cb 00 00 00    	je     80107abf <switchuvm+0xdf>
  if(p->kstack == 0)
801079f4:	8b 43 08             	mov    0x8(%ebx),%eax
801079f7:	85 c0                	test   %eax,%eax
801079f9:	0f 84 da 00 00 00    	je     80107ad9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801079ff:	8b 43 04             	mov    0x4(%ebx),%eax
80107a02:	85 c0                	test   %eax,%eax
80107a04:	0f 84 c2 00 00 00    	je     80107acc <switchuvm+0xec>
  pushcli();
80107a0a:	e8 01 d9 ff ff       	call   80105310 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a0f:	e8 bc bd ff ff       	call   801037d0 <mycpu>
80107a14:	89 c6                	mov    %eax,%esi
80107a16:	e8 b5 bd ff ff       	call   801037d0 <mycpu>
80107a1b:	89 c7                	mov    %eax,%edi
80107a1d:	e8 ae bd ff ff       	call   801037d0 <mycpu>
80107a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a25:	83 c7 08             	add    $0x8,%edi
80107a28:	e8 a3 bd ff ff       	call   801037d0 <mycpu>
80107a2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a30:	83 c0 08             	add    $0x8,%eax
80107a33:	ba 67 00 00 00       	mov    $0x67,%edx
80107a38:	c1 e8 18             	shr    $0x18,%eax
80107a3b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107a42:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107a49:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a4f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a54:	83 c1 08             	add    $0x8,%ecx
80107a57:	c1 e9 10             	shr    $0x10,%ecx
80107a5a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107a60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a65:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a6c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107a71:	e8 5a bd ff ff       	call   801037d0 <mycpu>
80107a76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a7d:	e8 4e bd ff ff       	call   801037d0 <mycpu>
80107a82:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a86:	8b 73 08             	mov    0x8(%ebx),%esi
80107a89:	e8 42 bd ff ff       	call   801037d0 <mycpu>
80107a8e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a94:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a97:	e8 34 bd ff ff       	call   801037d0 <mycpu>
80107a9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107aa0:	b8 28 00 00 00       	mov    $0x28,%eax
80107aa5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107aa8:	8b 43 04             	mov    0x4(%ebx),%eax
80107aab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ab0:	0f 22 d8             	mov    %eax,%cr3
}
80107ab3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ab6:	5b                   	pop    %ebx
80107ab7:	5e                   	pop    %esi
80107ab8:	5f                   	pop    %edi
80107ab9:	5d                   	pop    %ebp
  popcli();
80107aba:	e9 91 d8 ff ff       	jmp    80105350 <popcli>
    panic("switchuvm: no process");
80107abf:	83 ec 0c             	sub    $0xc,%esp
80107ac2:	68 be 8a 10 80       	push   $0x80108abe
80107ac7:	e8 c4 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107acc:	83 ec 0c             	sub    $0xc,%esp
80107acf:	68 e9 8a 10 80       	push   $0x80108ae9
80107ad4:	e8 b7 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107ad9:	83 ec 0c             	sub    $0xc,%esp
80107adc:	68 d4 8a 10 80       	push   $0x80108ad4
80107ae1:	e8 aa 88 ff ff       	call   80100390 <panic>
80107ae6:	8d 76 00             	lea    0x0(%esi),%esi
80107ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107af0 <inituvm>:
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 1c             	sub    $0x1c,%esp
80107af9:	8b 75 10             	mov    0x10(%ebp),%esi
80107afc:	8b 45 08             	mov    0x8(%ebp),%eax
80107aff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107b02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107b08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107b0b:	77 49                	ja     80107b56 <inituvm+0x66>
  mem = kalloc();
80107b0d:	e8 ae a9 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107b12:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107b15:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107b17:	68 00 10 00 00       	push   $0x1000
80107b1c:	6a 00                	push   $0x0
80107b1e:	50                   	push   %eax
80107b1f:	e8 cc d9 ff ff       	call   801054f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b24:	58                   	pop    %eax
80107b25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b30:	5a                   	pop    %edx
80107b31:	6a 06                	push   $0x6
80107b33:	50                   	push   %eax
80107b34:	31 d2                	xor    %edx,%edx
80107b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b39:	e8 c2 fc ff ff       	call   80107800 <mappages>
  memmove(mem, init, sz);
80107b3e:	89 75 10             	mov    %esi,0x10(%ebp)
80107b41:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107b44:	83 c4 10             	add    $0x10,%esp
80107b47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107b4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b4d:	5b                   	pop    %ebx
80107b4e:	5e                   	pop    %esi
80107b4f:	5f                   	pop    %edi
80107b50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b51:	e9 4a da ff ff       	jmp    801055a0 <memmove>
    panic("inituvm: more than a page");
80107b56:	83 ec 0c             	sub    $0xc,%esp
80107b59:	68 fd 8a 10 80       	push   $0x80108afd
80107b5e:	e8 2d 88 ff ff       	call   80100390 <panic>
80107b63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b70 <loaduvm>:
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	57                   	push   %edi
80107b74:	56                   	push   %esi
80107b75:	53                   	push   %ebx
80107b76:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107b79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107b80:	0f 85 91 00 00 00    	jne    80107c17 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107b86:	8b 75 18             	mov    0x18(%ebp),%esi
80107b89:	31 db                	xor    %ebx,%ebx
80107b8b:	85 f6                	test   %esi,%esi
80107b8d:	75 1a                	jne    80107ba9 <loaduvm+0x39>
80107b8f:	eb 6f                	jmp    80107c00 <loaduvm+0x90>
80107b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107ba4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107ba7:	76 57                	jbe    80107c00 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bac:	8b 45 08             	mov    0x8(%ebp),%eax
80107baf:	31 c9                	xor    %ecx,%ecx
80107bb1:	01 da                	add    %ebx,%edx
80107bb3:	e8 c8 fb ff ff       	call   80107780 <walkpgdir>
80107bb8:	85 c0                	test   %eax,%eax
80107bba:	74 4e                	je     80107c0a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107bbc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107bbe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107bc1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107bc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107bcb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107bd1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107bd4:	01 d9                	add    %ebx,%ecx
80107bd6:	05 00 00 00 80       	add    $0x80000000,%eax
80107bdb:	57                   	push   %edi
80107bdc:	51                   	push   %ecx
80107bdd:	50                   	push   %eax
80107bde:	ff 75 10             	pushl  0x10(%ebp)
80107be1:	e8 7a 9d ff ff       	call   80101960 <readi>
80107be6:	83 c4 10             	add    $0x10,%esp
80107be9:	39 f8                	cmp    %edi,%eax
80107beb:	74 ab                	je     80107b98 <loaduvm+0x28>
}
80107bed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bf5:	5b                   	pop    %ebx
80107bf6:	5e                   	pop    %esi
80107bf7:	5f                   	pop    %edi
80107bf8:	5d                   	pop    %ebp
80107bf9:	c3                   	ret    
80107bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c03:	31 c0                	xor    %eax,%eax
}
80107c05:	5b                   	pop    %ebx
80107c06:	5e                   	pop    %esi
80107c07:	5f                   	pop    %edi
80107c08:	5d                   	pop    %ebp
80107c09:	c3                   	ret    
      panic("loaduvm: address should exist");
80107c0a:	83 ec 0c             	sub    $0xc,%esp
80107c0d:	68 17 8b 10 80       	push   $0x80108b17
80107c12:	e8 79 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107c17:	83 ec 0c             	sub    $0xc,%esp
80107c1a:	68 b8 8b 10 80       	push   $0x80108bb8
80107c1f:	e8 6c 87 ff ff       	call   80100390 <panic>
80107c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c30 <allocuvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107c39:	8b 7d 10             	mov    0x10(%ebp),%edi
80107c3c:	85 ff                	test   %edi,%edi
80107c3e:	0f 88 8e 00 00 00    	js     80107cd2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107c44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107c47:	0f 82 93 00 00 00    	jb     80107ce0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c50:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107c56:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107c5c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107c5f:	0f 86 7e 00 00 00    	jbe    80107ce3 <allocuvm+0xb3>
80107c65:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107c68:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c6b:	eb 42                	jmp    80107caf <allocuvm+0x7f>
80107c6d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107c70:	83 ec 04             	sub    $0x4,%esp
80107c73:	68 00 10 00 00       	push   $0x1000
80107c78:	6a 00                	push   $0x0
80107c7a:	50                   	push   %eax
80107c7b:	e8 70 d8 ff ff       	call   801054f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107c80:	58                   	pop    %eax
80107c81:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107c87:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c8c:	5a                   	pop    %edx
80107c8d:	6a 06                	push   $0x6
80107c8f:	50                   	push   %eax
80107c90:	89 da                	mov    %ebx,%edx
80107c92:	89 f8                	mov    %edi,%eax
80107c94:	e8 67 fb ff ff       	call   80107800 <mappages>
80107c99:	83 c4 10             	add    $0x10,%esp
80107c9c:	85 c0                	test   %eax,%eax
80107c9e:	78 50                	js     80107cf0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107ca0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ca6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107ca9:	0f 86 81 00 00 00    	jbe    80107d30 <allocuvm+0x100>
    mem = kalloc();
80107caf:	e8 0c a8 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107cb4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107cb6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107cb8:	75 b6                	jne    80107c70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107cba:	83 ec 0c             	sub    $0xc,%esp
80107cbd:	68 35 8b 10 80       	push   $0x80108b35
80107cc2:	e8 99 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107cc7:	83 c4 10             	add    $0x10,%esp
80107cca:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ccd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107cd0:	77 6e                	ja     80107d40 <allocuvm+0x110>
}
80107cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107cd5:	31 ff                	xor    %edi,%edi
}
80107cd7:	89 f8                	mov    %edi,%eax
80107cd9:	5b                   	pop    %ebx
80107cda:	5e                   	pop    %esi
80107cdb:	5f                   	pop    %edi
80107cdc:	5d                   	pop    %ebp
80107cdd:	c3                   	ret    
80107cde:	66 90                	xchg   %ax,%ax
    return oldsz;
80107ce0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ce6:	89 f8                	mov    %edi,%eax
80107ce8:	5b                   	pop    %ebx
80107ce9:	5e                   	pop    %esi
80107cea:	5f                   	pop    %edi
80107ceb:	5d                   	pop    %ebp
80107cec:	c3                   	ret    
80107ced:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107cf0:	83 ec 0c             	sub    $0xc,%esp
80107cf3:	68 4d 8b 10 80       	push   $0x80108b4d
80107cf8:	e8 63 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107cfd:	83 c4 10             	add    $0x10,%esp
80107d00:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d03:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d06:	76 0d                	jbe    80107d15 <allocuvm+0xe5>
80107d08:	89 c1                	mov    %eax,%ecx
80107d0a:	8b 55 10             	mov    0x10(%ebp),%edx
80107d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d10:	e8 7b fb ff ff       	call   80107890 <deallocuvm.part.0>
      kfree(mem);
80107d15:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107d18:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107d1a:	56                   	push   %esi
80107d1b:	e8 f0 a5 ff ff       	call   80102310 <kfree>
      return 0;
80107d20:	83 c4 10             	add    $0x10,%esp
}
80107d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d26:	89 f8                	mov    %edi,%eax
80107d28:	5b                   	pop    %ebx
80107d29:	5e                   	pop    %esi
80107d2a:	5f                   	pop    %edi
80107d2b:	5d                   	pop    %ebp
80107d2c:	c3                   	ret    
80107d2d:	8d 76 00             	lea    0x0(%esi),%esi
80107d30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d36:	5b                   	pop    %ebx
80107d37:	89 f8                	mov    %edi,%eax
80107d39:	5e                   	pop    %esi
80107d3a:	5f                   	pop    %edi
80107d3b:	5d                   	pop    %ebp
80107d3c:	c3                   	ret    
80107d3d:	8d 76 00             	lea    0x0(%esi),%esi
80107d40:	89 c1                	mov    %eax,%ecx
80107d42:	8b 55 10             	mov    0x10(%ebp),%edx
80107d45:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107d48:	31 ff                	xor    %edi,%edi
80107d4a:	e8 41 fb ff ff       	call   80107890 <deallocuvm.part.0>
80107d4f:	eb 92                	jmp    80107ce3 <allocuvm+0xb3>
80107d51:	eb 0d                	jmp    80107d60 <deallocuvm>
80107d53:	90                   	nop
80107d54:	90                   	nop
80107d55:	90                   	nop
80107d56:	90                   	nop
80107d57:	90                   	nop
80107d58:	90                   	nop
80107d59:	90                   	nop
80107d5a:	90                   	nop
80107d5b:	90                   	nop
80107d5c:	90                   	nop
80107d5d:	90                   	nop
80107d5e:	90                   	nop
80107d5f:	90                   	nop

80107d60 <deallocuvm>:
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d69:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107d6c:	39 d1                	cmp    %edx,%ecx
80107d6e:	73 10                	jae    80107d80 <deallocuvm+0x20>
}
80107d70:	5d                   	pop    %ebp
80107d71:	e9 1a fb ff ff       	jmp    80107890 <deallocuvm.part.0>
80107d76:	8d 76 00             	lea    0x0(%esi),%esi
80107d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107d80:	89 d0                	mov    %edx,%eax
80107d82:	5d                   	pop    %ebp
80107d83:	c3                   	ret    
80107d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d90:	55                   	push   %ebp
80107d91:	89 e5                	mov    %esp,%ebp
80107d93:	57                   	push   %edi
80107d94:	56                   	push   %esi
80107d95:	53                   	push   %ebx
80107d96:	83 ec 0c             	sub    $0xc,%esp
80107d99:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d9c:	85 f6                	test   %esi,%esi
80107d9e:	74 59                	je     80107df9 <freevm+0x69>
80107da0:	31 c9                	xor    %ecx,%ecx
80107da2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107da7:	89 f0                	mov    %esi,%eax
80107da9:	e8 e2 fa ff ff       	call   80107890 <deallocuvm.part.0>
80107dae:	89 f3                	mov    %esi,%ebx
80107db0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107db6:	eb 0f                	jmp    80107dc7 <freevm+0x37>
80107db8:	90                   	nop
80107db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dc0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107dc3:	39 fb                	cmp    %edi,%ebx
80107dc5:	74 23                	je     80107dea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107dc7:	8b 03                	mov    (%ebx),%eax
80107dc9:	a8 01                	test   $0x1,%al
80107dcb:	74 f3                	je     80107dc0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107dcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107dd2:	83 ec 0c             	sub    $0xc,%esp
80107dd5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107dd8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107ddd:	50                   	push   %eax
80107dde:	e8 2d a5 ff ff       	call   80102310 <kfree>
80107de3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107de6:	39 fb                	cmp    %edi,%ebx
80107de8:	75 dd                	jne    80107dc7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107dea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107df0:	5b                   	pop    %ebx
80107df1:	5e                   	pop    %esi
80107df2:	5f                   	pop    %edi
80107df3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107df4:	e9 17 a5 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107df9:	83 ec 0c             	sub    $0xc,%esp
80107dfc:	68 69 8b 10 80       	push   $0x80108b69
80107e01:	e8 8a 85 ff ff       	call   80100390 <panic>
80107e06:	8d 76 00             	lea    0x0(%esi),%esi
80107e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e10 <setupkvm>:
{
80107e10:	55                   	push   %ebp
80107e11:	89 e5                	mov    %esp,%ebp
80107e13:	56                   	push   %esi
80107e14:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107e15:	e8 a6 a6 ff ff       	call   801024c0 <kalloc>
80107e1a:	85 c0                	test   %eax,%eax
80107e1c:	89 c6                	mov    %eax,%esi
80107e1e:	74 42                	je     80107e62 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107e20:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e23:	bb 40 b4 10 80       	mov    $0x8010b440,%ebx
  memset(pgdir, 0, PGSIZE);
80107e28:	68 00 10 00 00       	push   $0x1000
80107e2d:	6a 00                	push   $0x0
80107e2f:	50                   	push   %eax
80107e30:	e8 bb d6 ff ff       	call   801054f0 <memset>
80107e35:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107e38:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107e3b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e3e:	83 ec 08             	sub    $0x8,%esp
80107e41:	8b 13                	mov    (%ebx),%edx
80107e43:	ff 73 0c             	pushl  0xc(%ebx)
80107e46:	50                   	push   %eax
80107e47:	29 c1                	sub    %eax,%ecx
80107e49:	89 f0                	mov    %esi,%eax
80107e4b:	e8 b0 f9 ff ff       	call   80107800 <mappages>
80107e50:	83 c4 10             	add    $0x10,%esp
80107e53:	85 c0                	test   %eax,%eax
80107e55:	78 19                	js     80107e70 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e57:	83 c3 10             	add    $0x10,%ebx
80107e5a:	81 fb 80 b4 10 80    	cmp    $0x8010b480,%ebx
80107e60:	75 d6                	jne    80107e38 <setupkvm+0x28>
}
80107e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e65:	89 f0                	mov    %esi,%eax
80107e67:	5b                   	pop    %ebx
80107e68:	5e                   	pop    %esi
80107e69:	5d                   	pop    %ebp
80107e6a:	c3                   	ret    
80107e6b:	90                   	nop
80107e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107e70:	83 ec 0c             	sub    $0xc,%esp
80107e73:	56                   	push   %esi
      return 0;
80107e74:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e76:	e8 15 ff ff ff       	call   80107d90 <freevm>
      return 0;
80107e7b:	83 c4 10             	add    $0x10,%esp
}
80107e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e81:	89 f0                	mov    %esi,%eax
80107e83:	5b                   	pop    %ebx
80107e84:	5e                   	pop    %esi
80107e85:	5d                   	pop    %ebp
80107e86:	c3                   	ret    
80107e87:	89 f6                	mov    %esi,%esi
80107e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e90 <kvmalloc>:
{
80107e90:	55                   	push   %ebp
80107e91:	89 e5                	mov    %esp,%ebp
80107e93:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e96:	e8 75 ff ff ff       	call   80107e10 <setupkvm>
80107e9b:	a3 c4 72 11 80       	mov    %eax,0x801172c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107ea0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ea5:	0f 22 d8             	mov    %eax,%cr3
}
80107ea8:	c9                   	leave  
80107ea9:	c3                   	ret    
80107eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107eb0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107eb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107eb1:	31 c9                	xor    %ecx,%ecx
{
80107eb3:	89 e5                	mov    %esp,%ebp
80107eb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebe:	e8 bd f8 ff ff       	call   80107780 <walkpgdir>
  if(pte == 0)
80107ec3:	85 c0                	test   %eax,%eax
80107ec5:	74 05                	je     80107ecc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ec7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107eca:	c9                   	leave  
80107ecb:	c3                   	ret    
    panic("clearpteu");
80107ecc:	83 ec 0c             	sub    $0xc,%esp
80107ecf:	68 7a 8b 10 80       	push   $0x80108b7a
80107ed4:	e8 b7 84 ff ff       	call   80100390 <panic>
80107ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ee0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107ee0:	55                   	push   %ebp
80107ee1:	89 e5                	mov    %esp,%ebp
80107ee3:	57                   	push   %edi
80107ee4:	56                   	push   %esi
80107ee5:	53                   	push   %ebx
80107ee6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107ee9:	e8 22 ff ff ff       	call   80107e10 <setupkvm>
80107eee:	85 c0                	test   %eax,%eax
80107ef0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ef3:	0f 84 9f 00 00 00    	je     80107f98 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107efc:	85 c9                	test   %ecx,%ecx
80107efe:	0f 84 94 00 00 00    	je     80107f98 <copyuvm+0xb8>
80107f04:	31 ff                	xor    %edi,%edi
80107f06:	eb 4a                	jmp    80107f52 <copyuvm+0x72>
80107f08:	90                   	nop
80107f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f10:	83 ec 04             	sub    $0x4,%esp
80107f13:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107f19:	68 00 10 00 00       	push   $0x1000
80107f1e:	53                   	push   %ebx
80107f1f:	50                   	push   %eax
80107f20:	e8 7b d6 ff ff       	call   801055a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107f25:	58                   	pop    %eax
80107f26:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f2c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f31:	5a                   	pop    %edx
80107f32:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f35:	50                   	push   %eax
80107f36:	89 fa                	mov    %edi,%edx
80107f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f3b:	e8 c0 f8 ff ff       	call   80107800 <mappages>
80107f40:	83 c4 10             	add    $0x10,%esp
80107f43:	85 c0                	test   %eax,%eax
80107f45:	78 61                	js     80107fa8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107f47:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107f4d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107f50:	76 46                	jbe    80107f98 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f52:	8b 45 08             	mov    0x8(%ebp),%eax
80107f55:	31 c9                	xor    %ecx,%ecx
80107f57:	89 fa                	mov    %edi,%edx
80107f59:	e8 22 f8 ff ff       	call   80107780 <walkpgdir>
80107f5e:	85 c0                	test   %eax,%eax
80107f60:	74 61                	je     80107fc3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107f62:	8b 00                	mov    (%eax),%eax
80107f64:	a8 01                	test   $0x1,%al
80107f66:	74 4e                	je     80107fb6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107f68:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107f6a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107f6f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107f78:	e8 43 a5 ff ff       	call   801024c0 <kalloc>
80107f7d:	85 c0                	test   %eax,%eax
80107f7f:	89 c6                	mov    %eax,%esi
80107f81:	75 8d                	jne    80107f10 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107f83:	83 ec 0c             	sub    $0xc,%esp
80107f86:	ff 75 e0             	pushl  -0x20(%ebp)
80107f89:	e8 02 fe ff ff       	call   80107d90 <freevm>
  return 0;
80107f8e:	83 c4 10             	add    $0x10,%esp
80107f91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f9e:	5b                   	pop    %ebx
80107f9f:	5e                   	pop    %esi
80107fa0:	5f                   	pop    %edi
80107fa1:	5d                   	pop    %ebp
80107fa2:	c3                   	ret    
80107fa3:	90                   	nop
80107fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107fa8:	83 ec 0c             	sub    $0xc,%esp
80107fab:	56                   	push   %esi
80107fac:	e8 5f a3 ff ff       	call   80102310 <kfree>
      goto bad;
80107fb1:	83 c4 10             	add    $0x10,%esp
80107fb4:	eb cd                	jmp    80107f83 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107fb6:	83 ec 0c             	sub    $0xc,%esp
80107fb9:	68 9e 8b 10 80       	push   $0x80108b9e
80107fbe:	e8 cd 83 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107fc3:	83 ec 0c             	sub    $0xc,%esp
80107fc6:	68 84 8b 10 80       	push   $0x80108b84
80107fcb:	e8 c0 83 ff ff       	call   80100390 <panic>

80107fd0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107fd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fd1:	31 c9                	xor    %ecx,%ecx
{
80107fd3:	89 e5                	mov    %esp,%ebp
80107fd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107fde:	e8 9d f7 ff ff       	call   80107780 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107fe3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107fe5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107fe6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107fe8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107fed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ff0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ff5:	83 fa 05             	cmp    $0x5,%edx
80107ff8:	ba 00 00 00 00       	mov    $0x0,%edx
80107ffd:	0f 45 c2             	cmovne %edx,%eax
}
80108000:	c3                   	ret    
80108001:	eb 0d                	jmp    80108010 <copyout>
80108003:	90                   	nop
80108004:	90                   	nop
80108005:	90                   	nop
80108006:	90                   	nop
80108007:	90                   	nop
80108008:	90                   	nop
80108009:	90                   	nop
8010800a:	90                   	nop
8010800b:	90                   	nop
8010800c:	90                   	nop
8010800d:	90                   	nop
8010800e:	90                   	nop
8010800f:	90                   	nop

80108010 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108010:	55                   	push   %ebp
80108011:	89 e5                	mov    %esp,%ebp
80108013:	57                   	push   %edi
80108014:	56                   	push   %esi
80108015:	53                   	push   %ebx
80108016:	83 ec 1c             	sub    $0x1c,%esp
80108019:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010801c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010801f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108022:	85 db                	test   %ebx,%ebx
80108024:	75 40                	jne    80108066 <copyout+0x56>
80108026:	eb 70                	jmp    80108098 <copyout+0x88>
80108028:	90                   	nop
80108029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108030:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108033:	89 f1                	mov    %esi,%ecx
80108035:	29 d1                	sub    %edx,%ecx
80108037:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010803d:	39 d9                	cmp    %ebx,%ecx
8010803f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108042:	29 f2                	sub    %esi,%edx
80108044:	83 ec 04             	sub    $0x4,%esp
80108047:	01 d0                	add    %edx,%eax
80108049:	51                   	push   %ecx
8010804a:	57                   	push   %edi
8010804b:	50                   	push   %eax
8010804c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010804f:	e8 4c d5 ff ff       	call   801055a0 <memmove>
    len -= n;
    buf += n;
80108054:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108057:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010805a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108060:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108062:	29 cb                	sub    %ecx,%ebx
80108064:	74 32                	je     80108098 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108066:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108068:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010806b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010806e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108074:	56                   	push   %esi
80108075:	ff 75 08             	pushl  0x8(%ebp)
80108078:	e8 53 ff ff ff       	call   80107fd0 <uva2ka>
    if(pa0 == 0)
8010807d:	83 c4 10             	add    $0x10,%esp
80108080:	85 c0                	test   %eax,%eax
80108082:	75 ac                	jne    80108030 <copyout+0x20>
  }
  return 0;
}
80108084:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010808c:	5b                   	pop    %ebx
8010808d:	5e                   	pop    %esi
8010808e:	5f                   	pop    %edi
8010808f:	5d                   	pop    %ebp
80108090:	c3                   	ret    
80108091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010809b:	31 c0                	xor    %eax,%eax
}
8010809d:	5b                   	pop    %ebx
8010809e:	5e                   	pop    %esi
8010809f:	5f                   	pop    %edi
801080a0:	5d                   	pop    %ebp
801080a1:	c3                   	ret    
