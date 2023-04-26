import rospy
from std_msgs.msg import String
from gpsr_nlp.msg import nlpCommands


def parse_cmd(command):
    return command + ' parsed'


if __name__ == '__main__':
    print('starting')
    rospy.init_node('nlp_node')
    pub = rospy.Publisher('dialog', nlpCommands, queue_size=10)
    rate = rospy.Rate(1)

    while not rospy.is_shutdown():
        cmd = input('Enter your command! \n')
        cmd = parse_cmd(cmd)
        cmd = [cmd, cmd]
        pub.publish(cmd)
        print('published your command...')
        rate.sleep()
