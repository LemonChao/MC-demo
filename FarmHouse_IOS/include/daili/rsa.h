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
	/*bignum[98]������������ţ�1����0��bignum[99]�����ʵ�ʳ���*/
	struct slink *next;
};
/**
 *�����������
 */
void sub(int a[MAX], int b[MAX], int c[MAX]);

void print(int a[MAX]);
/**
 *�����ȽϺ���
 */
int cmp(int a1[MAX], int a2[MAX]);
/**
 *��������ת������
 */
void mov(int a[MAX], int *b);
/**
 *�����˻�����
 */
void mul(int a1[MAX], int a2[MAX], int *c);
/**
 *������Ӻ���
 */
void add(int a1[MAX], int a2[MAX], int *c);
/**
 *�����������
 */
void sub(int a1[MAX], int a2[MAX], int *c);
/**
 *����ȡģ����
 */
void mod(int a[MAX], int b[MAX], int *c);
/**
 *�����������
 */
void divt(int t[MAX], int b[MAX], int *c, int *w);
/**
 *��� �� m=a*b mod n;
 */
void mulmod(int a[MAX], int b[MAX], int n[MAX], int *m);
/**
 * ���������ص�������Ҫ���ֽ�� m=a^p  mod n�ĺ������⡣
 * ��� m=a^p  mod n�ĺ�������
 */
void expmod(int a[MAX], int p[MAX], int n[MAX], int *m);
/**
 * �ж��Ƿ�Ϊ����
 */
int is_prime_san(int p[MAX]);
/**
 * �ж���������֮���Ƿ���
 */
int coprime(int e[MAX], int s[MAX]);
/**
 * �����������
 */
void prime_random(int *p, int *q);
/**
 *��������
 */
void erand(int e[MAX], int m[MAX]);
/**
 *���ݹ��������������
 */
void rsad(int e[MAX], int g[MAX], int *d);
/*/
 *�������Կd�ĺ���(����Euclid�㷨)96403770511368768000
 */
unsigned long rsa(unsigned long p, unsigned long q, unsigned long e);
/**
 *���빫Կ
 */
//void loadpkey(int e[MAX], int n[MAX]);
void loadpkey(int e[MAX], int n[MAX], const char *sev_pk_file);
/**
 *����˽Կ
 */
//void loadskey(int d[MAX], int n[MAX]);
void loadskey(int d[MAX], int n[MAX], const char *dev_sk_file);
/**
 *������Կ
 */
void savepkey(int e[MAX], int n[MAX]);
/**
 *����˽Կ
 */
void saveskey(int d[MAX], int n[MAX]);
/**
 *
 */
void printbig(struct slink *h);

/**
 *����,���ؼ��ܺ�����ĳ���
 */
//int tencrypto(int e[MAX], int n[MAX], const char * expressly);
int tencrypto(char * ciphertext, u32 length, int e[MAX], int n[MAX], const char * expressly);//������Ҫ���ļ����м���//

/**
 *����
 */
//int tdecrypto(int d[MAX], int n[MAX]);
//int tdecrypto(char *expressly, u32 length, int d[MAX], int n[MAX]);
int tdecrypto(char *expressly, u32 length, int d[MAX], int n[MAX], const char * ciphertext);
/**
 *��������ַ�
 */
//struct slink *input(void);
struct slink *input(const char *src_ptr);
/**
*����
*/
struct slink *jiami(int e[MAX], int n[MAX], struct slink *head);
/**
*����
*/
void jiemi(int d[MAX], int n[MAX], struct slink *h);
/*
 * ���������������Կ
 */
void save_sev_pkstr(int e[MAX], int n[MAX], const char *dpk_str);
/**
 *������ʼ��
 **/
void rsa_init();

void load_dev_sk(int d[MAX], int n[MAX], const char *dsk_str);
/****************************************************************************************************************/
/**************************************** ����Ϊ���ⲿ���õĽӿں��� **********************************************/
/**
 * ������Կ�����ع�Կ��˽Կ
 */
void generate_key();
/**
 * key_type:
 * 0.��Կ
 * 1.˽Կ
 */
//void load_key(int key_type);
void load_key(int key_type, const char * dev_file);
/*
 * ���汾����Կ �����ܼ�������Կ��
 */
void save_key();
/**
 *�������ķ�������
 **/
char *rsa_encryption(char *ciphertext, u32 length, const char* expressly);
/**
 *�������ķ�������
 **/
//char *rsa_decryption(char *expressly, u32 length);
char *rsa_decryption(char *expressly, u32 length, const char * ciphertext);
/**
 *���������������Կ
 **/
void save_sev_pukey(const char *dpk_str);
/**
 *��ȡ���ؼ�����Կ
 */
void get_pukey(char * pukey, int len);
/**
 *���ؽ�����Կ
 */
void load_dev_skey(const char *skey_str);

void get_snkey(char *sdkey, int len);
#endif // RSA_H
