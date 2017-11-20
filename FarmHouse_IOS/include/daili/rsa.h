#ifndef RSA_H
#define RSA_H

#define MAX 100

#define MAXLINE 1024


#define RECV_CONTENT_FILE  "/sdcard/recv_text.au"
#define SEND_CONTENT_FILE "/sdcard/send_text.au"
#define ENCRYPTION_KEY "/sdcard/encryption_key.jl"//Encryption Key
#define DECRYPTION_KEY "/sdcard/decryption_key.jl"//Decryption key
#define NULL_STR "null"
#define KEY_TYPE_PK 0
#define KEY_TYPE_SK 1
#define FILENAME_LEN 50
#define PU_KEY_LEN 256
#define KEY_MAX_LEN 50

#define LEN sizeof(struct slink)

typedef unsigned int u32;

struct slink
{
	int bignum[MAX];
	/*bignum[98]用来标记正负号，1正，0负bignum[99]来标记实际长度*/
	struct slink *next;
};
/**
 *大数相减函数
 */
void sub(int a[MAX], int b[MAX], int c[MAX]);

void print(int a[MAX]);
/**
 *大数比较函数
 */
int cmp(int a1[MAX], int a2[MAX]);
/**
 *大数类型转换函数
 */
void mov(int a[MAX], int *b);
/**
 *大数乘积函数
 */
void mul(int a1[MAX], int a2[MAX], int *c);
/**
 *大数相加函数
 */
void add(int a1[MAX], int a2[MAX], int *c);
/**
 *大数相减函数
 */
void sub(int a1[MAX], int a2[MAX], int *c);
/**
 *大数取模函数
 */
void mod(int a[MAX], int b[MAX], int *c);
/**
 *大数相除函数
 */
void divt(int t[MAX], int b[MAX], int *c, int *w);
/**
 *解决 了 m=a*b mod n;
 */
void mulmod(int a[MAX], int b[MAX], int n[MAX], int *m);
/**
 * 接下来的重点任务是要着手解决 m=a^p  mod n的函数问题。
 * 解决 m=a^p  mod n的函数问题
 */
void expmod(int a[MAX], int p[MAX], int n[MAX], int *m);
/**
 * 判断是否为素数
 */
int is_prime_san(int p[MAX]);
/**
 * 判断两个大数之间是否互质
 */
int coprime(int e[MAX], int s[MAX]);
/**
 * 随机产生素数
 */
void prime_random(int *p, int *q);
/**
 *产生素数
 */
void erand(int e[MAX], int m[MAX]);
/**
 *根据规则产生其他的数
 */
void rsad(int e[MAX], int g[MAX], int *d);
/*/
 *求解密密钥d的函数(根据Euclid算法)96403770511368768000
 */
unsigned long rsa(unsigned long p, unsigned long q, unsigned long e);
/**
 *导入公钥
 */
//void loadpkey(int e[MAX], int n[MAX]);
void loadpkey(int e[MAX], int n[MAX], const char *sev_pk_file);
/**
 *导入私钥
 */
//void loadskey(int d[MAX], int n[MAX]);
void loadskey(int d[MAX], int n[MAX], const char *dev_sk_file);
/**
 *导出公钥
 */
void savepkey(int e[MAX], int n[MAX]);
/**
 *导出私钥
 */
void saveskey(int d[MAX], int n[MAX]);
/**
 *
 */
void printbig(struct slink *h);

/**
 *加密,返回加密后的密文长度
 */
//int tencrypto(int e[MAX], int n[MAX], const char * expressly);
int tencrypto(char * ciphertext, u32 length, int e[MAX], int n[MAX], const char * expressly);//对有需要的文件进行加密//

/**
 *解密
 */
//int tdecrypto(int d[MAX], int n[MAX]);
//int tdecrypto(char *expressly, u32 length, int d[MAX], int n[MAX]);
int tdecrypto(char *expressly, u32 length, int d[MAX], int n[MAX], const char * ciphertext);
/**
 *输入加密字符
 */
//struct slink *input(void);
struct slink *input(const char *src_ptr);
/**
*加密
*/
struct slink *jiami(int e[MAX], int n[MAX], struct slink *head);
/**
*解密
*/
void jiemi(int d[MAX], int n[MAX], struct slink *h);
/*
 * 载入服务器加密密钥
 */
void save_sev_pkstr(int e[MAX], int n[MAX], const char *dpk_str);
/**
 *变量初始化
 **/
void rsa_init();

void load_dev_sk(int d[MAX], int n[MAX], const char *dsk_str);
/****************************************************************************************************************/
/**************************************** 以下为供外部调用的接口函数 **********************************************/
/**
 * 生成密钥，本地公钥、私钥
 */
void generate_key();
/**
 * key_type:
 * 0.公钥
 * 1.私钥
 */
//void load_key(int key_type);
void load_key(int key_type, const char * dev_file);
/*
 * 保存本地密钥 （加密及解密密钥）
 */
void save_key();
/**
 *加密明文返回密文
 **/
char *rsa_encryption(char *ciphertext, u32 length, const char* expressly);
/**
 *解密密文返回明文
 **/
//char *rsa_decryption(char *expressly, u32 length);
char *rsa_decryption(char *expressly, u32 length, const char * ciphertext);
/**
 *保存服务器加密密钥
 **/
void save_sev_pukey(const char *dpk_str);
/**
 *获取本地加密密钥
 */
void get_pukey(char * pukey, int len);
/**
 *加载解密密钥
 */
void load_dev_skey(const char *skey_str);

void get_snkey(char *sdkey, int len);
#endif // RSA_H
