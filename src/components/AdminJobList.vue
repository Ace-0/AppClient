<template>
    <el-row>
        <el-table :data="getJobs()" stripe>
            <el-table-column prop="job_id" label="任务编号"></el-table-column>
            <el-table-column prop="image_id" label="图片编号"></el-table-column>
            <el-table-column prop="label_id" label="标注编号"></el-table-column>
            <el-table-column prop="nickname" label="医生昵称"></el-table-column>
            <el-table-column prop="state" label="状态"></el-table-column>
            <el-table-column prop="finished_date" label="完成日期"></el-table-column>
        </el-table>

        <el-row>
            <el-pagination
                @size-change="changeJobPageSize"
                @current-change="changeJobPageCurrent"
                :current-page="jobPageCurrent"
                :page-sizes="jobPageSizes"
                :page-size="jobPageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="jobs.length">
            </el-pagination>
        </el-row>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AdminJobList',
  components: {
    // ...
  },

  data() {
    return {
      jobs: [],
      accounts: [],

      jobPageCurrent: 1,  // 当前任务列表页码数
      jobPageSizes: [5, 10, 30, 50, 1000, 2000, 5000],  // 可选任务列表页面最大项目数列表
      jobPageSize: 10  // 任务列表页面最大项目数
    }
  },
  created() {
    // load data
    this.loadAccounts()
    this.loadJobs()
  },
  methods: {
    loadAccounts() {
      this.$http.get(config.apiUrl + '/accounts/').then(res => {
        this.accounts = res.body.data;
      }, res => {
        this.$message.error('请求任务信息错误')
        // eslint-disable-next-line
        console.log(res)
      });
    },
    loadJobs() {
      this.$http.get(config.apiUrl + '/jobs/').then(res => {  // NEED
        this.jobs = res.body.data;
        var jobStateCode = { '200': '未标注', '201': '标注中', '202': '已完成' }
        for (var i = 0; i < this.jobs.length; i++) {
            this.jobs[i].state = jobStateCode[this.jobs[i].job_state]
            for (var j = 0; j < this.accounts.length; j++) {
            if (this.jobs[i].account_id == this.accounts[j].account_id) {
                this.jobs[i].nickname = this.accounts[j].nickname
              }
            }
        }
      }, res => {
        this.$message.error('请求任务信息错误')
        // eslint-disable-next-line
        console.log(res)
      });
    },
    changeJobPageSize: function (val) {
        this.jobPageSize = val;
    },
    changeJobPageCurrent: function (val) {
        this.jobPageCurrent = val;
    },
    getJobs() {
        var len = this.jobs.length;
        if (this.jobPageSize >= len) {
            return this.jobs;
        } else {
            var jobPages = [];
            for (var i = 0; i < len; i += this.jobPageSize) {
                if (i + this.jobPageSize >= len) {
                    jobPages.push(this.jobs.slice(i));
                } else {
                    jobPages.push(this.jobs.slice(i, i + this.jobPageSize));
                }
            }
            return jobPages[this.jobPageCurrent - 1];
        }
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
